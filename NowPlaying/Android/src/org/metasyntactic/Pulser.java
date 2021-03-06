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
package org.metasyntactic;

import android.os.Handler;
import org.metasyntactic.utilities.LogUtilities;

import java.util.Date;

public class Pulser {
  private final Runnable runnable;
  private Date lastPulseTime;
  private final int pulseIntervalSeconds;

  public Pulser(final Runnable runnable, final int pulseIntervalSeconds) {
    lastPulseTime = new Date(0);
    this.runnable = runnable;
    this.pulseIntervalSeconds = pulseIntervalSeconds;
  }

  private void tryPulse(final Date date) {
    // LogUtilities.i("tryPulse", "pulse tried");
    if (date.before(lastPulseTime)) {
      // we sent out a pulse after this one. just disregard this pulse
      // LogUtilities.i(Pulser.class.getName(), "Pulse at " + date + " < last pulse at "
      // + lastPulseTime + ". Disregarding");
      return;
    }
    final Date now = new Date();
    final Date nextViablePulseTime = new Date(lastPulseTime.getTime() + 1000 * pulseIntervalSeconds);
    if (now.before(nextViablePulseTime)) {
      // too soon since the last pulse. wait until later.
      // LogUtilities.i(Pulser.class.getName(), "Pulse at " + date + "too soon since last
      // pulse at " + lastPulseTime + ". Will perform later.");
      final Runnable tryPulseLater = new Runnable() {
        public void run() {
          tryPulse(date);
        }
      };
      if (!new Handler().postDelayed(tryPulseLater, pulseIntervalSeconds * 1000)) {
        throw new RuntimeException();
      }
      return;
    }
    // ok, actually pulse.
    lastPulseTime = now;
    LogUtilities.i(Pulser.class.getName(), "Pulse at " + date + " being performed at " + lastPulseTime);
    runnable.run();
  }

  public void forcePulse() {
    lastPulseTime = new Date();
    LogUtilities.i(Pulser.class.getName(), "Forced pulse at: " + lastPulseTime);
    runnable.run();
  }

  public void tryPulse() {
    tryPulse(new Date());
  }
}
