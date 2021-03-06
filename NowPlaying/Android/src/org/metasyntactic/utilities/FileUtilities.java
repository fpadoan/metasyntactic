//Copyright 2008 Cyrus Najmabadi
//
//Licensed under the Apache License, Version 2.0 (the "License");
//you may not use this file except in compliance with the License.
//You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//Unless required by applicable law or agreed to in writing, software
//distributed under the License is distributed on an "AS IS" BASIS,
//WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//See the License for the specific language governing permissions and
//limitations under the License.
package org.metasyntactic.utilities;

import android.os.Environment;
import org.metasyntactic.NowPlayingApplication;
import org.metasyntactic.io.Persistable;
import org.metasyntactic.io.PersistableInputStream;
import org.metasyntactic.io.PersistableOutputStream;
import org.metasyntactic.time.Days;
import static org.metasyntactic.utilities.CollectionUtilities.nonNullCollection;
import static org.metasyntactic.utilities.CollectionUtilities.nonNullMap;

import java.io.BufferedOutputStream;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.UnsupportedEncodingException;
import java.util.Collection;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class FileUtilities {
  private static final boolean USE_PERSISTABLE = true;
  private static final Object gate = new Object();
  private static final byte[] EMPTY_BYTE_ARRAY = new byte[0];

  private static boolean sdcardAccessible = true;

  private static final Map<String, String> sanitizedNameMap = new HashMap<String, String>();

  static {
    sdcardAccessible = Environment.getExternalStorageState().equals(Environment.MEDIA_MOUNTED);
  }

  public static void setSDCardAccessible(final boolean sdcardAccessible) {
    synchronized (gate) {
      FileUtilities.sdcardAccessible = sdcardAccessible;
    }
  }

  public static boolean isSDCardAccessible() {
    return sdcardAccessible;
  }

  private FileUtilities() {
  }

  public static int daysSinceNow(final File file) {
    final Date today = DateUtilities.getToday();
    final Date releaseDate = new Date(file.lastModified());

    return Days.daysBetween(today, releaseDate);
  }

  public static String sanitizeFileNameWorker(final String name) {
    final StringBuilder result = new StringBuilder(name.length() * 2);
    for (final char c : name.toCharArray()) {
      if (isLegalCharacter(c)) {
        result.append(c);
      } else {
        result.append('-');
        result.append((int)c);
        result.append('-');
      }
    }
    return result.toString();
  }

  public static String sanitizeFileName(final String name) {
    synchronized (gate) {
      String result = sanitizedNameMap.get(name);
      if (result == null) {
        result = sanitizeFileNameWorker(name);
        sanitizedNameMap.put(name, result);
      }
      return result;
    }
  }

  public static void onLowMemory() {
    synchronized (gate) {
      sanitizedNameMap.clear();
    }
  }

  private static boolean isLegalCharacter(final char c) {
    return c >= 'a' && c <= 'z' || c >= 'A' && c <= 'Z' || c >= '0' && c <= '9' || c == ' ' || c == '-' || c == '.';
  }

  @SuppressWarnings("unchecked")
  public static <T> T readObject(final File file) {
    try {
      final byte[] bytes = readBytes(file);
      if (bytes.length == 0) {
        return null;
      }
      final ObjectInputStream in = new ObjectInputStream(new ByteArrayInputStream(bytes));
      return (T)in.readObject();
    } catch (final IOException ignored) {
      return null;
    } catch (final ClassNotFoundException e) {
      throw new RuntimeException(e);
    }
  }

  public static void writeObject(final Object object, final File file) {
    try {
      if (object == null) {
        writeBytes(EMPTY_BYTE_ARRAY, file);
        return;
      }

      final ByteArrayOutputStream byteOut = new ByteArrayOutputStream(1 << 13);
      final ObjectOutputStream out = new ObjectOutputStream(byteOut);

      out.writeObject(object);

      out.flush();
      out.close();

      writeBytes(byteOut.toByteArray(), file);
    } catch (final IOException e) {
      ExceptionUtilities.log(FileUtilities.class, "writeObject", e);
    }
  }

  private static PersistableInputStream createInputStream(final File file) throws FileNotFoundException {
    return new PersistableInputStream(new DataInputStream(new FileInputStream(file)));
  }

  private static PersistableOutputStream createOutputStream(final ByteArrayOutputStream byteOut) {
    return new PersistableOutputStream(new DataOutputStream(byteOut));
  }

  public static Map<String, Date> readStringToDateMap(final File file) {
    if (!file.exists()) {
      return Collections.emptyMap();
    }

    if (USE_PERSISTABLE) {
      try {
        final PersistableInputStream in = createInputStream(file);
        final Map<String, Date> result = new HashMap<String, Date>();

        final int size = in.readInt();
        for (int i = 0; i < size; i++) {
          final String key = in.readString();
          final Date value = in.readDate();

          result.put(key, value);
        }

        in.close();
        return result;
      } catch (final IOException e) {
        ExceptionUtilities.log(FileUtilities.class, "readStringToDateMap", e);
        return Collections.emptyMap();
      }
    } else {
      return readObject(file);
    }
  }

  public static void writeStringToDateMap(Map<String, Date> map, final File file) {
    map = nonNullMap(map);

    if (USE_PERSISTABLE) {
      try {
        final ByteArrayOutputStream byteOut = new ByteArrayOutputStream(1 << 13);
        final PersistableOutputStream out = createOutputStream(byteOut);

        out.writeInt(map.size());
        for (final Map.Entry<String, Date> e : map.entrySet()) {
          out.writeString(e.getKey());
          out.writeDate(e.getValue());
        }

        out.flush();
        out.close();

        writeBytes(byteOut.toByteArray(), file);
      } catch (final IOException e) {
        ExceptionUtilities.log(FileUtilities.class, "writeStringToDateMap", e);
      }
    } else {
      writeObject(map, file);
    }
  }

  public static Map<String, String> readStringToStringMap(final File file) {
    if (!file.exists()) {
      return Collections.emptyMap();
    }

    if (USE_PERSISTABLE) {
      try {
        final PersistableInputStream in = createInputStream(file);
        final Map<String, String> result = new HashMap<String, String>();

        final int size = in.readInt();
        for (int i = 0; i < size; i++) {
          final String key = in.readString();
          final String value = in.readString();

          result.put(key, value);
        }

        in.close();
        return result;
      } catch (final IOException e) {
        ExceptionUtilities.log(FileUtilities.class, "readStringToStringMap", e);
        return Collections.emptyMap();
      }
    } else {
      return readObject(file);
    }
  }

  public static void writeStringToStringMap(Map<String, String> map, final File file) {
    map = nonNullMap(map);

    if (USE_PERSISTABLE) {
      try {
        final ByteArrayOutputStream byteOut = new ByteArrayOutputStream(1 << 13);
        final PersistableOutputStream out = createOutputStream(byteOut);

        out.writeInt(map.size());
        for (final Map.Entry<String, String> e : map.entrySet()) {
          out.writeString(e.getKey());
          out.writeString(e.getValue());
        }

        out.flush();
        out.close();

        writeBytes(byteOut.toByteArray(), file);
      } catch (final IOException e) {
        ExceptionUtilities.log(FileUtilities.class, "writeStringToStringMap", e);
      }
    } else {
      writeObject(map, file);
    }
  }

  public static <T extends Persistable> Map<String, T> readStringToPersistableMap(final Persistable.Reader<T> reader, final File file) {
    if (!file.exists()) {
      return Collections.emptyMap();
    }

    if (USE_PERSISTABLE) {
      try {
        final PersistableInputStream in = createInputStream(file);
        final int size = in.readInt();

        final Map<String, T> result = new HashMap<String, T>(size);
        for (int i = 0; i < size; i++) {
          final String key = in.readString();
          final T value = in.readPersistable(reader);

          result.put(key, value);
        }

        in.close();

        return result;
      } catch (final IOException e) {
        ExceptionUtilities.log(FileUtilities.class, "readStringToPersistableMap", e);
        return Collections.emptyMap();
      }
    } else {
      return readObject(file);
    }
  }

  public static <T extends Persistable> void writeStringToPersistableMap(Map<String, T> map, final File file) {
    map = nonNullMap(map);

    if (USE_PERSISTABLE) {
      try {
        final ByteArrayOutputStream byteOut = new ByteArrayOutputStream(1 << 13);
        final PersistableOutputStream out = createOutputStream(byteOut);

        out.writeInt(map.size());
        for (final Map.Entry<String, T> e : map.entrySet()) {
          out.writeString(e.getKey());
          out.writePersistable(e.getValue());
        }

        out.flush();
        out.close();

        writeBytes(byteOut.toByteArray(), file);
      } catch (final IOException e) {
        ExceptionUtilities.log(FileUtilities.class, "writeStringToPersistableMap", e);
      }
    } else {
      writeObject(map, file);
    }
  }

  public static List<String> readStringList(final File file) {
    if (!file.exists()) {
      return Collections.emptyList();
    }

    if (USE_PERSISTABLE) {
      try {
        final PersistableInputStream in = createInputStream(file);
        final List<String> result = in.readStringList();

        in.close();
        return result;
      } catch (final IOException e) {
        ExceptionUtilities.log(FileUtilities.class, "readStringList", e);
        return Collections.emptyList();
      }
    } else {
      return readObject(file);
    }
  }

  public static void writeStringCollection(Collection<String> collection, final File file) {
    collection = nonNullCollection(collection);

    if (USE_PERSISTABLE) {
      try {
        final ByteArrayOutputStream byteOut = new ByteArrayOutputStream(1 << 13);
        final PersistableOutputStream out = createOutputStream(byteOut);
        out.writeStringCollection(collection);

        out.flush();
        out.close();

        writeBytes(byteOut.toByteArray(), file);
      } catch (final IOException e) {
        ExceptionUtilities.log(FileUtilities.class, "writeStringCollection", e);
      }
    } else {
      writeObject(collection, file);
    }
  }

  public static String readString(final File file) {
    if (!file.exists()) {
      return null;
    }

    try {
      return new String(readBytes(file), "UTF-8");
    } catch (final UnsupportedEncodingException e) {
      throw new RuntimeException(e);
    }
  }

  public static void writeString(final String s, final File file) {
    try {
      writeBytes(s.getBytes("UTF-8"), file);
    } catch (final IOException e) {
      ExceptionUtilities.log(FileUtilities.class, "writeString", e);
    }
  }

  public static <T extends Persistable> T readPersistable(final Persistable.Reader<T> reader, final File file) {
    if (!file.exists()) {
      return null;
    }

    if (USE_PERSISTABLE) {
      try {
        final PersistableInputStream in = createInputStream(file);
        final T result = in.readPersistable(reader);

        in.close();
        return result;
      } catch (final IOException e) {
        ExceptionUtilities.log(FileUtilities.class, "readPersistable", e);
        return null;
      }
    } else {
      return readObject(file);
    }
  }

  public static void writePersistable(final Persistable p, final File file) {
    if (USE_PERSISTABLE) {
      try {
        final ByteArrayOutputStream byteOut = new ByteArrayOutputStream();
        final PersistableOutputStream out = createOutputStream(byteOut);
        out.writePersistable(p);

        out.flush();
        out.close();

        writeBytes(byteOut.toByteArray(), file);
      } catch (final IOException e) {
        ExceptionUtilities.log(FileUtilities.class, "writePersistable", e);
      }
    } else {
      writeObject(p, file);
    }
  }

  public static <T extends Persistable> List<T> readPersistableList(final Persistable.Reader<T> reader, final File file) {
    if (!file.exists()) {
      return Collections.emptyList();
    }

    if (USE_PERSISTABLE) {
      try {
        final PersistableInputStream in = createInputStream(file);
        final List<T> result = reader.readList(in);

        in.close();
        return result;
      } catch (final IOException e) {
        ExceptionUtilities.log(FileUtilities.class, "readPersistableList", e);
        return Collections.emptyList();
      }
    } else {
      return readObject(file);
    }
  }

  public static <T extends Persistable> void writePersistableCollection(Collection<T> collection, final File file) {
    collection = nonNullCollection(collection);

    if (USE_PERSISTABLE) {
      try {
        final ByteArrayOutputStream byteOut = new ByteArrayOutputStream();
        final PersistableOutputStream out = createOutputStream(byteOut);
        out.writeInt(collection.size());
        for (final T t : collection) {
          out.writePersistable(t);
        }

        out.flush();
        out.close();

        writeBytes(byteOut.toByteArray(), file);
      } catch (final IOException e) {
        ExceptionUtilities.log(FileUtilities.class, "writePersistableCollection", e);
      }
    } else {
      writeObject(collection, file);
    }
  }

  public static <T extends Persistable> Map<String, List<T>> readStringToListOfPersistables(final Persistable.Reader<T> reader, final File file) {
    if (!file.exists()) {
      return Collections.emptyMap();
    }

    if (USE_PERSISTABLE) {
      try {
        final PersistableInputStream in = createInputStream(file);
        final int size = in.readInt();

        final Map<String, List<T>> result = new HashMap<String, List<T>>(size);
        for (int i = 0; i < size; i++) {
          final String key = in.readString();
          final List<T> value = reader.readList(in);
          result.put(key, value);
        }

        in.close();
        return result;
      } catch (final IOException e) {
        ExceptionUtilities.log(FileUtilities.class, "readStringToListOfPersistables", e);
        return Collections.emptyMap();
      }
    } else {
      return readObject(file);
    }
  }

  public static <T extends Persistable> void writeStringToListOfPersistables(Map<String, List<T>> map, final File file) {
    map = nonNullMap(map);

    if (USE_PERSISTABLE) {
      try {
        final ByteArrayOutputStream byteOut = new ByteArrayOutputStream(1 << 13);
        final PersistableOutputStream out = createOutputStream(byteOut);

        out.writeInt(map.size());
        for (final Map.Entry<String, List<T>> e : map.entrySet()) {
          out.writeString(e.getKey());
          out.writePersistableCollection(e.getValue());
        }

        out.flush();
        out.close();

        writeBytes(byteOut.toByteArray(), file);
      } catch (final IOException e) {
        ExceptionUtilities.log(FileUtilities.class, "writeStringToListOfPersistables", e);
      }
    } else {
      writeObject(map, file);
    }
  }

  public static Map<String, List<String>> readStringToListOfStrings(final File file) {
    if (!file.exists()) {
      return Collections.emptyMap();
    }

    if (USE_PERSISTABLE) {
      try {
        final PersistableInputStream in = createInputStream(file);
        final int size = in.readInt();

        final Map<String, List<String>> result = new HashMap<String, List<String>>(size);
        for (int i = 0; i < size; i++) {
          final String key = in.readString();
          final List<String> value = in.readStringList();
          result.put(key, value);
        }

        in.close();
        return result;
      } catch (final IOException e) {
        ExceptionUtilities.log(FileUtilities.class, "readStringToListOfStrings", e);
        return Collections.emptyMap();
      }
    } else {
      return readObject(file);
    }
  }

  public static void writeStringToListOfStrings(Map<String, List<String>> map, final File file) {
    map = nonNullMap(map);

    if (USE_PERSISTABLE) {
      try {
        final ByteArrayOutputStream byteOut = new ByteArrayOutputStream(1 << 13);
        final PersistableOutputStream out = createOutputStream(byteOut);

        out.writeInt(map.size());
        for (final Map.Entry<String, List<String>> e : map.entrySet()) {
          out.writeString(e.getKey());
          out.writeStringCollection(e.getValue());
        }

        out.flush();
        out.close();

        writeBytes(byteOut.toByteArray(), file);
      } catch (final IOException e) {
        ExceptionUtilities.log(FileUtilities.class, "writeStringToListOfStrings", e);
      } catch (InternalError e) {
        NowPlayingApplication.deleteItem(file);
      }
    } else {
      writeObject(map, file);
    }
  }

  public static byte[] readBytes(final File file) {
    if (file == null || !file.exists() || !sdcardAccessible) {
      return EMPTY_BYTE_ARRAY;
    }

    try {
      final FileInputStream in = new FileInputStream(file);
      final ByteArrayOutputStream byteStream = new ByteArrayOutputStream();

      final byte[] bytes = new byte[1 << 13];
      int read;
      while ((read = in.read(bytes)) >= 0) {
        byteStream.write(bytes, 0, read);
      }
      in.close();

      return byteStream.toByteArray();
    } catch (final IOException e) {
      ExceptionUtilities.log(FileUtilities.class, "readBytes", e);
      return null;
    }
  }

  public static void writeBytes(byte[] data, final File file) {
    try {
      if (!sdcardAccessible) {
        return;
      }

      if (data == null) {
        data = EMPTY_BYTE_ARRAY;
      }

      final File tempFile = File.createTempFile("WBT", "T" + Math.random(), NowPlayingApplication.tempDirectory);
      final BufferedOutputStream out = new BufferedOutputStream(new FileOutputStream(tempFile), 1 << 13);
      out.write(data);

      out.flush();
      out.close();

      tempFile.renameTo(file);
    } catch (final IOException e) {
      ExceptionUtilities.log(FileUtilities.class, "writeBytes", e);
    }
  }
}
