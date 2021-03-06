// Generated by the protocol buffer compiler.  DO NOT EDIT!

#include "google/protobuf/objectivec-descriptor.pb.h"
#include <google/protobuf/stubs/once.h>
#include <google/protobuf/descriptor.h>
#include <google/protobuf/io/coded_stream.h>
#include <google/protobuf/reflection_ops.h>
#include <google/protobuf/wire_format_inl.h>

namespace google {
namespace protobuf {

namespace {

const ::google::protobuf::Descriptor* ObjectiveCFileOptions_descriptor_ = NULL;
const ::google::protobuf::internal::GeneratedMessageReflection*
  ObjectiveCFileOptions_reflection_ = NULL;

}  // namespace


void protobuf_AssignDesc_google_2fprotobuf_2fobjectivec_2ddescriptor_2eproto() {
  protobuf_AddDesc_google_2fprotobuf_2fobjectivec_2ddescriptor_2eproto();
  const ::google::protobuf::FileDescriptor* file =
    ::google::protobuf::DescriptorPool::generated_pool()->FindFileByName(
      "google/protobuf/objectivec-descriptor.proto");
  GOOGLE_CHECK(file != NULL);
  ObjectiveCFileOptions_descriptor_ = file->message_type(0);
  static const int ObjectiveCFileOptions_offsets_[2] = {
    GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(ObjectiveCFileOptions, objectivec_package_),
    GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(ObjectiveCFileOptions, objectivec_class_prefix_),
  };
  ObjectiveCFileOptions_reflection_ =
    new ::google::protobuf::internal::GeneratedMessageReflection(
      ObjectiveCFileOptions_descriptor_,
      ObjectiveCFileOptions::default_instance_,
      ObjectiveCFileOptions_offsets_,
      GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(ObjectiveCFileOptions, _has_bits_[0]),
      GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(ObjectiveCFileOptions, _unknown_fields_),
      -1,
      ::google::protobuf::DescriptorPool::generated_pool(),
      ::google::protobuf::MessageFactory::generated_factory(),
      sizeof(ObjectiveCFileOptions));
}

namespace {

GOOGLE_PROTOBUF_DECLARE_ONCE(protobuf_AssignDescriptors_once_);
inline void protobuf_AssignDescriptorsOnce() {
  ::google::protobuf::GoogleOnceInit(&protobuf_AssignDescriptors_once_,
                 &protobuf_AssignDesc_google_2fprotobuf_2fobjectivec_2ddescriptor_2eproto);
}

void protobuf_RegisterTypes() {
  protobuf_AssignDescriptorsOnce();
  ::google::protobuf::MessageFactory::InternalRegisterGeneratedMessage(
    ObjectiveCFileOptions_descriptor_, &ObjectiveCFileOptions::default_instance());
}

}  // namespace

void protobuf_ShutdownFile_google_2fprotobuf_2fobjectivec_2ddescriptor_2eproto() {
  delete ObjectiveCFileOptions::default_instance_;
  delete ObjectiveCFileOptions_reflection_;
}

void protobuf_AddDesc_google_2fprotobuf_2fobjectivec_2ddescriptor_2eproto() {
  static bool already_here = false;
  if (already_here) return;
  already_here = true;
  GOOGLE_PROTOBUF_VERIFY_VERSION;

  ::google::protobuf::protobuf_AddDesc_google_2fprotobuf_2fdescriptor_2eproto();
  ::google::protobuf::DescriptorPool::InternalAddGeneratedFile(
    "\n+google/protobuf/objectivec-descriptor."
    "proto\022\017google.protobuf\032 google/protobuf/"
    "descriptor.proto\"T\n\025ObjectiveCFileOption"
    "s\022\032\n\022objectivec_package\030\001 \001(\t\022\037\n\027objecti"
    "vec_class_prefix\030\002 \001(\t:f\n\027objectivec_fil"
    "e_options\022\034.google.protobuf.FileOptions\030"
    "\352\007 \001(\0132&.google.protobuf.ObjectiveCFileO"
    "ptions", 286);
  ::google::protobuf::MessageFactory::InternalRegisterGeneratedFile(
    "google/protobuf/objectivec-descriptor.proto", &protobuf_RegisterTypes);
  ObjectiveCFileOptions::default_instance_ = new ObjectiveCFileOptions();
  ::google::protobuf::internal::ExtensionSet::RegisterMessageExtension(
    &::google::protobuf::FileOptions::default_instance(),
    1002, 11, false, false,
    &::google::protobuf::ObjectiveCFileOptions::default_instance());
  ObjectiveCFileOptions::default_instance_->InitAsDefaultInstance();
  ::google::protobuf::internal::OnShutdown(&protobuf_ShutdownFile_google_2fprotobuf_2fobjectivec_2ddescriptor_2eproto);
}

// Force AddDescriptors() to be called at static initialization time.
struct StaticDescriptorInitializer_google_2fprotobuf_2fobjectivec_2ddescriptor_2eproto {
  StaticDescriptorInitializer_google_2fprotobuf_2fobjectivec_2ddescriptor_2eproto() {
    protobuf_AddDesc_google_2fprotobuf_2fobjectivec_2ddescriptor_2eproto();
  }
} static_descriptor_initializer_google_2fprotobuf_2fobjectivec_2ddescriptor_2eproto_;


// ===================================================================

const ::std::string ObjectiveCFileOptions::_default_objectivec_package_;
const ::std::string ObjectiveCFileOptions::_default_objectivec_class_prefix_;
#ifndef _MSC_VER
const int ObjectiveCFileOptions::kObjectivecPackageFieldNumber;
const int ObjectiveCFileOptions::kObjectivecClassPrefixFieldNumber;
#endif  // !_MSC_VER

ObjectiveCFileOptions::ObjectiveCFileOptions()
  : ::google::protobuf::Message() {
  SharedCtor();
}

void ObjectiveCFileOptions::InitAsDefaultInstance() {}

ObjectiveCFileOptions::ObjectiveCFileOptions(const ObjectiveCFileOptions& from)
  : ::google::protobuf::Message() {
  SharedCtor();
  MergeFrom(from);
}

void ObjectiveCFileOptions::SharedCtor() {
  _cached_size_ = 0;
  objectivec_package_ = const_cast< ::std::string*>(&_default_objectivec_package_);
  objectivec_class_prefix_ = const_cast< ::std::string*>(&_default_objectivec_class_prefix_);
  ::memset(_has_bits_, 0, sizeof(_has_bits_));
}

ObjectiveCFileOptions::~ObjectiveCFileOptions() {
  SharedDtor();
}

void ObjectiveCFileOptions::SharedDtor() {
  if (objectivec_package_ != &_default_objectivec_package_) {
    delete objectivec_package_;
  }
  if (objectivec_class_prefix_ != &_default_objectivec_class_prefix_) {
    delete objectivec_class_prefix_;
  }
  if (this != default_instance_) {
  }
}

const ::google::protobuf::Descriptor* ObjectiveCFileOptions::descriptor() {
  protobuf_AssignDescriptorsOnce();
  return ObjectiveCFileOptions_descriptor_;
}

const ObjectiveCFileOptions& ObjectiveCFileOptions::default_instance() {
  if (default_instance_ == NULL) protobuf_AddDesc_google_2fprotobuf_2fobjectivec_2ddescriptor_2eproto();  return *default_instance_;
}

ObjectiveCFileOptions* ObjectiveCFileOptions::default_instance_ = NULL;

ObjectiveCFileOptions* ObjectiveCFileOptions::New() const {
  return new ObjectiveCFileOptions;
}

void ObjectiveCFileOptions::Clear() {
  if (_has_bits_[0 / 32] & (0xffu << (0 % 32))) {
    if (_has_bit(0)) {
      if (objectivec_package_ != &_default_objectivec_package_) {
        objectivec_package_->clear();
      }
    }
    if (_has_bit(1)) {
      if (objectivec_class_prefix_ != &_default_objectivec_class_prefix_) {
        objectivec_class_prefix_->clear();
      }
    }
  }
  ::memset(_has_bits_, 0, sizeof(_has_bits_));
  mutable_unknown_fields()->Clear();
}

bool ObjectiveCFileOptions::MergePartialFromCodedStream(
    ::google::protobuf::io::CodedInputStream* input) {
#define DO_(EXPRESSION) if (!(EXPRESSION)) return false
  ::google::protobuf::uint32 tag;
  while ((tag = input->ReadTag()) != 0) {
    switch (::google::protobuf::internal::WireFormat::GetTagFieldNumber(tag)) {
      // optional string objectivec_package = 1;
      case 1: {
        if (::google::protobuf::internal::WireFormat::GetTagWireType(tag) !=
            ::google::protobuf::internal::WireFormat::WIRETYPE_LENGTH_DELIMITED) {
          goto handle_uninterpreted;
        }
        DO_(::google::protobuf::internal::WireFormat::ReadString(input, mutable_objectivec_package()));
        if (input->ExpectTag(18)) goto parse_objectivec_class_prefix;
        break;
      }
      
      // optional string objectivec_class_prefix = 2;
      case 2: {
        if (::google::protobuf::internal::WireFormat::GetTagWireType(tag) !=
            ::google::protobuf::internal::WireFormat::WIRETYPE_LENGTH_DELIMITED) {
          goto handle_uninterpreted;
        }
       parse_objectivec_class_prefix:
        DO_(::google::protobuf::internal::WireFormat::ReadString(input, mutable_objectivec_class_prefix()));
        if (input->ExpectAtEnd()) return true;
        break;
      }
      
      default: {
      handle_uninterpreted:
        if (::google::protobuf::internal::WireFormat::GetTagWireType(tag) ==
            ::google::protobuf::internal::WireFormat::WIRETYPE_END_GROUP) {
          return true;
        }
        DO_(::google::protobuf::internal::WireFormat::SkipField(
              input, tag, mutable_unknown_fields()));
        break;
      }
    }
  }
  return true;
#undef DO_
}

void ObjectiveCFileOptions::SerializeWithCachedSizes(
    ::google::protobuf::io::CodedOutputStream* output) const {
  ::google::protobuf::uint8* raw_buffer = output->GetDirectBufferForNBytesAndAdvance(_cached_size_);
  if (raw_buffer != NULL) {
    ObjectiveCFileOptions::SerializeWithCachedSizesToArray(raw_buffer);
    return;
  }
  
  // optional string objectivec_package = 1;
  if (_has_bit(0)) {
    ::google::protobuf::internal::WireFormat::WriteString(1, this->objectivec_package(), output);
  }
  
  // optional string objectivec_class_prefix = 2;
  if (_has_bit(1)) {
    ::google::protobuf::internal::WireFormat::WriteString(2, this->objectivec_class_prefix(), output);
  }
  
  if (!unknown_fields().empty()) {
    ::google::protobuf::internal::WireFormat::SerializeUnknownFields(
        unknown_fields(), output);
  }
}

::google::protobuf::uint8* ObjectiveCFileOptions::SerializeWithCachedSizesToArray(
    ::google::protobuf::uint8* target) const {
  // optional string objectivec_package = 1;
  if (_has_bit(0)) {
    target = ::google::protobuf::internal::WireFormat::WriteStringToArray(1, this->objectivec_package(), target);
  }
  
  // optional string objectivec_class_prefix = 2;
  if (_has_bit(1)) {
    target = ::google::protobuf::internal::WireFormat::WriteStringToArray(2, this->objectivec_class_prefix(), target);
  }
  
  if (!unknown_fields().empty()) {
    target = ::google::protobuf::internal::WireFormat::SerializeUnknownFieldsToArray(
        unknown_fields(), target);
  }
  return target;
}

int ObjectiveCFileOptions::ByteSize() const {
  int total_size = 0;
  
  if (_has_bits_[0 / 32] & (0xffu << (0 % 32))) {
    // optional string objectivec_package = 1;
    if (has_objectivec_package()) {
      total_size += 1 +
        ::google::protobuf::internal::WireFormat::StringSize(this->objectivec_package());
    }
    
    // optional string objectivec_class_prefix = 2;
    if (has_objectivec_class_prefix()) {
      total_size += 1 +
        ::google::protobuf::internal::WireFormat::StringSize(this->objectivec_class_prefix());
    }
    
  }
  if (!unknown_fields().empty()) {
    total_size +=
      ::google::protobuf::internal::WireFormat::ComputeUnknownFieldsSize(
        unknown_fields());
  }
  _cached_size_ = total_size;
  return total_size;
}

void ObjectiveCFileOptions::MergeFrom(const ::google::protobuf::Message& from) {
  GOOGLE_CHECK_NE(&from, this);
  const ObjectiveCFileOptions* source =
    ::google::protobuf::internal::dynamic_cast_if_available<const ObjectiveCFileOptions*>(
      &from);
  if (source == NULL) {
    ::google::protobuf::internal::ReflectionOps::Merge(from, this);
  } else {
    MergeFrom(*source);
  }
}

void ObjectiveCFileOptions::MergeFrom(const ObjectiveCFileOptions& from) {
  GOOGLE_CHECK_NE(&from, this);
  if (from._has_bits_[0 / 32] & (0xffu << (0 % 32))) {
    if (from._has_bit(0)) {
      set_objectivec_package(from.objectivec_package());
    }
    if (from._has_bit(1)) {
      set_objectivec_class_prefix(from.objectivec_class_prefix());
    }
  }
  mutable_unknown_fields()->MergeFrom(from.unknown_fields());
}

void ObjectiveCFileOptions::CopyFrom(const ::google::protobuf::Message& from) {
  if (&from == this) return;
  Clear();
  MergeFrom(from);
}

void ObjectiveCFileOptions::CopyFrom(const ObjectiveCFileOptions& from) {
  if (&from == this) return;
  Clear();
  MergeFrom(from);
}

void ObjectiveCFileOptions::Swap(ObjectiveCFileOptions* other) {
  if (other != this) {
    std::swap(objectivec_package_, other->objectivec_package_);
    std::swap(objectivec_class_prefix_, other->objectivec_class_prefix_);
    std::swap(_has_bits_[0], other->_has_bits_[0]);
    _unknown_fields_.Swap(&other->_unknown_fields_);
    std::swap(_cached_size_, other->_cached_size_);
  }
}

bool ObjectiveCFileOptions::IsInitialized() const {
  
  return true;
}

const ::google::protobuf::Descriptor* ObjectiveCFileOptions::GetDescriptor() const {
  return descriptor();
}

const ::google::protobuf::Reflection* ObjectiveCFileOptions::GetReflection() const {
  protobuf_AssignDescriptorsOnce();
  return ObjectiveCFileOptions_reflection_;
}
::google::protobuf::internal::ExtensionIdentifier< ::google::protobuf::FileOptions,
    ::google::protobuf::internal::MessageTypeTraits< ::google::protobuf::ObjectiveCFileOptions >, 11, false >
  objectivec_file_options(kObjectivecFileOptionsFieldNumber, ::google::protobuf::ObjectiveCFileOptions::default_instance());

}  // namespace protobuf
}  // namespace google
