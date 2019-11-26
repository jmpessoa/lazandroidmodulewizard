//
//
//  Jni for Pascal
//
//  Original Source Code : /fpc/2.7.1/packages/jni/src/jni.pas
//
//
//
//
//
//
unit And_jni;
{$ifdef fpc}
 {$mode delphi}
 {$packrecords c}
{$endif}

{$SMARTLINK ON}

interface

(*
 * Manifest constants.
 *)
const JNI_FALSE=0;
      JNI_TRUE=1;

      JNI_VERSION_1_1=$00010001;
      JNI_VERSION_1_2=$00010002;
      JNI_VERSION_1_4=$00010004;
      JNI_VERSION_1_6=$00010006;

      JNI_OK=0;         // no error
      JNI_ERR=-1;       // generic error
      JNI_EDETACHED=-2; // thread detached from the VM
      JNI_EVERSION=-3;  // JNI version error

      JNI_COMMIT=1;     // copy content, do not free buffer
      JNI_ABORT=2;      // free buffer w/o copying back

(*
 * Type definitions.
 *)
type
     va_list=pointer;
     jboolean=byte;        // unsigned 8 bits
     jbyte=shortint;       // signed 8 bits
     jchar=word;           // unsigned 16 bits
     jshort=smallint;      // signed 16 bits
     jint=longint;         // signed 32 bits
     jlong=int64;          // signed 64 bits
     jfloat=single;        // 32-bit IEEE 754
     jdouble=double;       // 64-bit IEEE 754

     jsize=jint;           // "cardinal indices and sizes"

     Pjboolean=^jboolean;
     Pjbyte=^jbyte;
     Pjchar=^jchar;
     Pjshort=^jshort;
     Pjint=^jint;
     Pjlong=^jlong;
     Pjfloat=^jfloat;
     Pjdouble=^jdouble;

     Pjsize=^jsize;

     // Reference type
     jobject=pointer;
     jclass=jobject;
     jstring=jobject;
     jstringArray=jobject;  //by jmpessoa
     jarray=jobject;
     jobjectArray=jarray;
     jbooleanArray=jarray;
     jbyteArray=jarray;
     jcharArray=jarray;
     jshortArray=jarray;
     jintArray=jarray;
     jlongArray=jarray;
     jfloatArray=jarray;
     jdoubleArray=jarray;
     jthrowable=jobject;
     jweak=jobject;
     jref=jobject;

     PPointer=^pointer;
     Pjobject=^jobject;
     Pjclass=^jclass;
     Pjstring=^jstring;
     Pjarray=^jarray;
     PjobjectArray=^jobjectArray;
     PjbooleanArray=^jbooleanArray;
     PjbyteArray=^jbyteArray;
     PjcharArray=^jcharArray;
     PjshortArray=^jshortArray;
     PjintArray=^jintArray;
     PjlongArray=^jlongArray;
     PjfloatArray=^jfloatArray;
     PjdoubleArray=^jdoubleArray;
     Pjthrowable=^jthrowable;
     Pjweak=^jweak;
     Pjref=^jref;

     _jfieldID=record // opaque structure
     end;
     jfieldID=^_jfieldID;// field IDs
     PjfieldID=^jfieldID;

     _jmethodID=record // opaque structure
     end;
     jmethodID=^_jmethodID;// method IDs
     PjmethodID=^jmethodID;

     PJNIInvokeInterface=^JNIInvokeInterface;

     Pjvalue=^jvalue;
     jvalue={$ifdef packedrecords}packed{$endif} record
      case integer of
       0:(z:jboolean);
       1:(b:jbyte);
       2:(c:jchar);
       3:(s:jshort);
       4:(i:jint);
       5:(j:jlong);
       6:(f:jfloat);
       7:(d:jdouble);
       8:(l:jobject);
     end;

     jobjectRefType=(
      JNIInvalidRefType=0,
      JNILocalRefType=1,
      JNIGlobalRefType=2,
      JNIWeakGlobalRefType=3);

     PJNINativeMethod=^JNINativeMethod;
     JNINativeMethod={$ifdef packedrecords}packed{$endif} record
      name:pchar;
      signature:pchar;
      fnPtr:pointer;
     end;

     PJNINativeInterface=^JNINativeInterface;

     _JNIEnv={$ifdef packedrecords}packed{$endif} record
      functions:PJNINativeInterface;
     end;

     _JavaVM={$ifdef packedrecords}packed{$endif} record
      functions:PJNIInvokeInterface;
     end;

     C_JNIEnv=^JNINativeInterface;
     JNIEnv=^JNINativeInterface;
     JavaVM=^JNIInvokeInterface;

     PPJNIEnv=^PJNIEnv;
     PJNIEnv=^JNIEnv;

     PPJavaVM=^PJavaVM;
     PJavaVM=^JavaVM;

     JNINativeInterface={$ifdef packedrecords}packed{$endif} record
      reserved0:pointer;
      reserved1:pointer;
      reserved2:pointer;
      reserved3:pointer;

      GetVersion:function(Env:PJNIEnv):JInt;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      DefineClass:function(Env:PJNIEnv;const Name:pchar;Loader:JObject;const Buf:PJByte;Len:JSize):JClass;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      FindClass:function(Env:PJNIEnv;const Name:pchar):JClass;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}

      // Reflection Support
      FromReflectedMethod:function(Env:PJNIEnv;Method:JObject):JMethodID;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      FromReflectedField:function(Env:PJNIEnv;Field:JObject):JFieldID;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      ToReflectedMethod:function(Env:PJNIEnv;AClass:JClass;MethodID:JMethodID;IsStatic:JBoolean):JObject;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}

      GetSuperclass:function(Env:PJNIEnv;Sub:JClass):JClass;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      IsAssignableFrom:function(Env:PJNIEnv;Sub:JClass;Sup:JClass):JBoolean;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}

      // Reflection Support
      ToReflectedField:function(Env:PJNIEnv;AClass:JClass;FieldID:JFieldID;IsStatic:JBoolean):JObject;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}

      Throw:function(Env:PJNIEnv;Obj:JThrowable):JInt;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      ThrowNew:function(Env:PJNIEnv;AClass:JClass;const Msg:pchar):JInt;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      ExceptionOccurred:function(Env:PJNIEnv):JThrowable;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      ExceptionDescribe:procedure(Env:PJNIEnv);{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      ExceptionClear:procedure(Env:PJNIEnv);{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      FatalError:procedure(Env:PJNIEnv;const Msg:pchar);{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}

      // Local Reference Management
      PushLocalFrame:function(Env:PJNIEnv;Capacity:JInt):JInt;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      PopLocalFrame:function(Env:PJNIEnv;Result:JObject):JObject;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}

      NewGlobalRef:function(Env:PJNIEnv;LObj:JObject):JObject;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      DeleteGlobalRef:procedure(Env:PJNIEnv;GRef:JObject);{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      DeleteLocalRef:procedure(Env:PJNIEnv;Obj:JObject);{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      IsSameObject:function(Env:PJNIEnv;Obj1:JObject;Obj2:JObject):JBoolean;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}

      // Local Reference Management
      NewLocalRef:function(Env:PJNIEnv;Ref:JObject):JObject;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      EnsureLocalCapacity:function(Env:PJNIEnv;Capacity:JInt):JObject;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}

      AllocObject:function(Env:PJNIEnv;AClass:JClass):JObject;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      NewObject:function(Env:PJNIEnv;AClass:JClass;MethodID:JMethodID):JObject;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      NewObjectV:function(Env:PJNIEnv;AClass:JClass;MethodID:JMethodID;Args:va_list):JObject;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      NewObjectA:function(Env:PJNIEnv;AClass:JClass;MethodID:JMethodID;Args:PJValue):JObject;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}

      GetObjectClass:function(Env:PJNIEnv;Obj:JObject):JClass;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      IsInstanceOf:function(Env:PJNIEnv;Obj:JObject;AClass:JClass):JBoolean;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}

      GetMethodID:function(Env:PJNIEnv;AClass:JClass;const Name:pchar;const Sig:pchar):JMethodID;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}

      CallObjectMethod:function(Env:PJNIEnv;Obj:JObject;MethodID:JMethodID):JObject;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      CallObjectMethodV:function(Env:PJNIEnv;Obj:JObject;MethodID:JMethodID;Args:va_list):JObject;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      CallObjectMethodA:function(Env:PJNIEnv;Obj:JObject;MethodID:JMethodID;Args:PJValue):JObject;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}

      CallBooleanMethod:function(Env:PJNIEnv;Obj:JObject;MethodID:JMethodID):JBoolean;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      CallBooleanMethodV:function(Env:PJNIEnv;Obj:JObject;MethodID:JMethodID;Args:va_list):JBoolean;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      CallBooleanMethodA:function(Env:PJNIEnv;Obj:JObject;MethodID:JMethodID;Args:PJValue):JBoolean;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}

      CallByteMethod:function(Env:PJNIEnv;Obj:JObject;MethodID:JMethodID):JByte;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      CallByteMethodV:function(Env:PJNIEnv;Obj:JObject;MethodID:JMethodID;Args:va_list):JByte;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      CallByteMethodA:function(Env:PJNIEnv;Obj:JObject;MethodID:JMethodID;Args:PJValue):JByte;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}

      CallCharMethod:function(Env:PJNIEnv;Obj:JObject;MethodID:JMethodID):JChar;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      CallCharMethodV:function(Env:PJNIEnv;Obj:JObject;MethodID:JMethodID;Args:va_list):JChar;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      CallCharMethodA:function(Env:PJNIEnv;Obj:JObject;MethodID:JMethodID;Args:PJValue):JChar;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}

      CallShortMethod:function(Env:PJNIEnv;Obj:JObject;MethodID:JMethodID):JShort;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      CallShortMethodV:function(Env:PJNIEnv;Obj:JObject;MethodID:JMethodID;Args:va_list):JShort;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      CallShortMethodA:function(Env:PJNIEnv;Obj:JObject;MethodID:JMethodID;Args:PJValue):JShort;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}

      CallIntMethod:function(Env:PJNIEnv;Obj:JObject;MethodID:JMethodID):JInt;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      CallIntMethodV:function(Env:PJNIEnv;Obj:JObject;MethodID:JMethodID;Args:va_list):JInt;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      CallIntMethodA:function(Env:PJNIEnv;Obj:JObject;MethodID:JMethodID;Args:PJValue):JInt;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}

      CallLongMethod:function(Env:PJNIEnv;Obj:JObject;MethodID:JMethodID):JLong;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      CallLongMethodV:function(Env:PJNIEnv;Obj:JObject;MethodID:JMethodID;Args:va_list):JLong;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      CallLongMethodA:function(Env:PJNIEnv;Obj:JObject;MethodID:JMethodID;Args:PJValue):JLong;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}

      CallFloatMethod:function(Env:PJNIEnv;Obj:JObject;MethodID:JMethodID):JFloat;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      CallFloatMethodV:function(Env:PJNIEnv;Obj:JObject;MethodID:JMethodID;Args:va_list):JFloat;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      CallFloatMethodA:function(Env:PJNIEnv;Obj:JObject;MethodID:JMethodID;Args:PJValue):JFloat;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}

      CallDoubleMethod:function(Env:PJNIEnv;Obj:JObject;MethodID:JMethodID):JDouble;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      CallDoubleMethodV:function(Env:PJNIEnv;Obj:JObject;MethodID:JMethodID;Args:va_list):JDouble;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      CallDoubleMethodA:function(Env:PJNIEnv;Obj:JObject;MethodID:JMethodID;Args:PJValue):JDouble;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}

      CallVoidMethod:procedure(Env:PJNIEnv;Obj:JObject;MethodID:JMethodID);{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      CallVoidMethodV:procedure(Env:PJNIEnv;Obj:JObject;MethodID:JMethodID;Args:va_list);{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      CallVoidMethodA:procedure(Env:PJNIEnv;Obj:JObject;MethodID:JMethodID;Args:PJValue);{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}

      CallNonvirtualObjectMethod:function(Env:PJNIEnv;Obj:JObject;AClass:JClass;MethodID:JMethodID):JObject;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      CallNonvirtualObjectMethodV:function(Env:PJNIEnv;Obj:JObject;AClass:JClass;MethodID:JMethodID;Args:va_list):JObject;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      CallNonvirtualObjectMethodA:function(Env:PJNIEnv;Obj:JObject;AClass:JClass;MethodID:JMethodID;Args:PJValue):JObject;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}

      CallNonvirtualBooleanMethod:function(Env:PJNIEnv;Obj:JObject;AClass:JClass;MethodID:JMethodID):JBoolean;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      CallNonvirtualBooleanMethodV:function(Env:PJNIEnv;Obj:JObject;AClass:JClass;MethodID:JMethodID;Args:va_list):JBoolean;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      CallNonvirtualBooleanMethodA:function(Env:PJNIEnv;Obj:JObject;AClass:JClass;MethodID:JMethodID;Args:PJValue):JBoolean;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}

      CallNonvirtualByteMethod:function(Env:PJNIEnv;Obj:JObject;AClass:JClass;MethodID:JMethodID):JByte;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      CallNonvirtualByteMethodV:function(Env:PJNIEnv;Obj:JObject;AClass:JClass;MethodID:JMethodID;Args:va_list):JByte;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      CallNonvirtualByteMethodA:function(Env:PJNIEnv;Obj:JObject;AClass:JClass;MethodID:JMethodID;Args:PJValue):JByte;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}

      CallNonvirtualCharMethod:function(Env:PJNIEnv;Obj:JObject;AClass:JClass;MethodID:JMethodID):JChar;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      CallNonvirtualCharMethodV:function(Env:PJNIEnv;Obj:JObject;AClass:JClass;MethodID:JMethodID;Args:va_list):JChar;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      CallNonvirtualCharMethodA:function(Env:PJNIEnv;Obj:JObject;AClass:JClass;MethodID:JMethodID;Args:PJValue):JChar;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}

      CallNonvirtualShortMethod:function(Env:PJNIEnv;Obj:JObject;AClass:JClass;MethodID:JMethodID):JShort;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      CallNonvirtualShortMethodV:function(Env:PJNIEnv;Obj:JObject;AClass:JClass;MethodID:JMethodID;Args:va_list):JShort;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      CallNonvirtualShortMethodA:function(Env:PJNIEnv;Obj:JObject;AClass:JClass;MethodID:JMethodID;Args:PJValue):JShort;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}

      CallNonvirtualIntMethod:function(Env:PJNIEnv;Obj:JObject;AClass:JClass;MethodID:JMethodID):JInt;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      CallNonvirtualIntMethodV:function(Env:PJNIEnv;Obj:JObject;AClass:JClass;MethodID:JMethodID;Args:va_list):JInt;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      CallNonvirtualIntMethodA:function(Env:PJNIEnv;Obj:JObject;AClass:JClass;MethodID:JMethodID;Args:PJValue):JInt;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}

      CallNonvirtualLongMethod:function(Env:PJNIEnv;Obj:JObject;AClass:JClass;MethodID:JMethodID):JLong;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      CallNonvirtualLongMethodV:function(Env:PJNIEnv;Obj:JObject;AClass:JClass;MethodID:JMethodID;Args:va_list):JLong;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      CallNonvirtualLongMethodA:function(Env:PJNIEnv;Obj:JObject;AClass:JClass;MethodID:JMethodID;Args:PJValue):JLong;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}

      CallNonvirtualFloatMethod:function(Env:PJNIEnv;Obj:JObject;AClass:JClass;MethodID:JMethodID):JFloat;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      CallNonvirtualFloatMethodV:function(Env:PJNIEnv;Obj:JObject;AClass:JClass;MethodID:JMethodID;Args:va_list):JFloat;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      CallNonvirtualFloatMethodA:function(Env:PJNIEnv;Obj:JObject;AClass:JClass;MethodID:JMethodID;Args:PJValue):JFloat;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}

      CallNonvirtualDoubleMethod:function(Env:PJNIEnv;Obj:JObject;AClass:JClass;MethodID:JMethodID):JDouble;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      CallNonvirtualDoubleMethodV:function(Env:PJNIEnv;Obj:JObject;AClass:JClass;MethodID:JMethodID;Args:va_list):JDouble;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      CallNonvirtualDoubleMethodA:function(Env:PJNIEnv;Obj:JObject;AClass:JClass;MethodID:JMethodID;Args:PJValue):JDouble;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}

      CallNonvirtualVoidMethod:procedure(Env:PJNIEnv;Obj:JObject;AClass:JClass;MethodID:JMethodID);{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      CallNonvirtualVoidMethodV:procedure(Env:PJNIEnv;Obj:JObject;AClass:JClass;MethodID:JMethodID;Args:va_list);{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      CallNonvirtualVoidMethodA:procedure(Env:PJNIEnv;Obj:JObject;AClass:JClass;MethodID:JMethodID;Args:PJValue);{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}

      GetFieldID:function(Env:PJNIEnv;AClass:JClass;const Name:pchar;const Sig:pchar):JFieldID;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}

      GetObjectField:function(Env:PJNIEnv;Obj:JObject;FieldID:JFieldID):JObject;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      GetBooleanField:function(Env:PJNIEnv;Obj:JObject;FieldID:JFieldID):JBoolean;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      GetByteField:function(Env:PJNIEnv;Obj:JObject;FieldID:JFieldID):JByte;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      GetCharField:function(Env:PJNIEnv;Obj:JObject;FieldID:JFieldID):JChar;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      GetShortField:function(Env:PJNIEnv;Obj:JObject;FieldID:JFieldID):JShort;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      GetIntField:function(Env:PJNIEnv;Obj:JObject;FieldID:JFieldID):JInt;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      GetLongField:function(Env:PJNIEnv;Obj:JObject;FieldID:JFieldID):JLong;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      GetFloatField:function(Env:PJNIEnv;Obj:JObject;FieldID:JFieldID):JFloat;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      GetDoubleField:function(Env:PJNIEnv;Obj:JObject;FieldID:JFieldID):JDouble;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}

      SetObjectField:procedure(Env:PJNIEnv;Obj:JObject;FieldID:JFieldID;Val:JObject);{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      SetBooleanField:procedure(Env:PJNIEnv;Obj:JObject;FieldID:JFieldID;Val:JBoolean);{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      SetByteField:procedure(Env:PJNIEnv;Obj:JObject;FieldID:JFieldID;Val:JByte);{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      SetCharField:procedure(Env:PJNIEnv;Obj:JObject;FieldID:JFieldID;Val:JChar);{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      SetShortField:procedure(Env:PJNIEnv;Obj:JObject;FieldID:JFieldID;Val:JShort);{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      SetIntField:procedure(Env:PJNIEnv;Obj:JObject;FieldID:JFieldID;Val:JInt);{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      SetLongField:procedure(Env:PJNIEnv;Obj:JObject;FieldID:JFieldID;Val:JLong);{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      SetFloatField:procedure(Env:PJNIEnv;Obj:JObject;FieldID:JFieldID;Val:JFloat);{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      SetDoubleField:procedure(Env:PJNIEnv;Obj:JObject;FieldID:JFieldID;Val:JDouble);{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}

      GetStaticMethodID:function(Env:PJNIEnv;AClass:JClass;const Name:pchar;const Sig:pchar):JMethodID;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}

      CallStaticObjectMethod:function(Env:PJNIEnv;AClass:JClass;MethodID:JMethodID):JObject;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      CallStaticObjectMethodV:function(Env:PJNIEnv;AClass:JClass;MethodID:JMethodID;Args:va_list):JObject;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      CallStaticObjectMethodA:function(Env:PJNIEnv;AClass:JClass;MethodID:JMethodID;Args:PJValue):JObject;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}

      CallStaticBooleanMethod:function(Env:PJNIEnv;AClass:JClass;MethodID:JMethodID):JBoolean;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      CallStaticBooleanMethodV:function(Env:PJNIEnv;AClass:JClass;MethodID:JMethodID;Args:va_list):JBoolean;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      CallStaticBooleanMethodA:function(Env:PJNIEnv;AClass:JClass;MethodID:JMethodID;Args:PJValue):JBoolean;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}

      CallStaticByteMethod:function(Env:PJNIEnv;AClass:JClass;MethodID:JMethodID):JByte;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      CallStaticByteMethodV:function(Env:PJNIEnv;AClass:JClass;MethodID:JMethodID;Args:va_list):JByte;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      CallStaticByteMethodA:function(Env:PJNIEnv;AClass:JClass;MethodID:JMethodID;Args:PJValue):JByte;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}

      CallStaticCharMethod:function(Env:PJNIEnv;AClass:JClass;MethodID:JMethodID):JChar;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      CallStaticCharMethodV:function(Env:PJNIEnv;AClass:JClass;MethodID:JMethodID;Args:va_list):JChar;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      CallStaticCharMethodA:function(Env:PJNIEnv;AClass:JClass;MethodID:JMethodID;Args:PJValue):JChar;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}

      CallStaticShortMethod:function(Env:PJNIEnv;AClass:JClass;MethodID:JMethodID):JShort;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      CallStaticShortMethodV:function(Env:PJNIEnv;AClass:JClass;MethodID:JMethodID;Args:va_list):JShort;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      CallStaticShortMethodA:function(Env:PJNIEnv;AClass:JClass;MethodID:JMethodID;Args:PJValue):JShort;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}

      CallStaticIntMethod:function(Env:PJNIEnv;AClass:JClass;MethodID:JMethodID):JInt;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      CallStaticIntMethodV:function(Env:PJNIEnv;AClass:JClass;MethodID:JMethodID;Args:va_list):JInt;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      CallStaticIntMethodA:function(Env:PJNIEnv;AClass:JClass;MethodID:JMethodID;Args:PJValue):JInt;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}

      CallStaticLongMethod:function(Env:PJNIEnv;AClass:JClass;MethodID:JMethodID):JLong;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      CallStaticLongMethodV:function(Env:PJNIEnv;AClass:JClass;MethodID:JMethodID;Args:va_list):JLong;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      CallStaticLongMethodA:function(Env:PJNIEnv;AClass:JClass;MethodID:JMethodID;Args:PJValue):JLong;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}

      CallStaticFloatMethod:function(Env:PJNIEnv;AClass:JClass;MethodID:JMethodID):JFloat;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      CallStaticFloatMethodV:function(Env:PJNIEnv;AClass:JClass;MethodID:JMethodID;Args:va_list):JFloat;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      CallStaticFloatMethodA:function(Env:PJNIEnv;AClass:JClass;MethodID:JMethodID;Args:PJValue):JFloat;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}

      CallStaticDoubleMethod:function(Env:PJNIEnv;AClass:JClass;MethodID:JMethodID):JDouble;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      CallStaticDoubleMethodV:function(Env:PJNIEnv;AClass:JClass;MethodID:JMethodID;Args:va_list):JDouble;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      CallStaticDoubleMethodA:function(Env:PJNIEnv;AClass:JClass;MethodID:JMethodID;Args:PJValue):JDouble;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}

      CallStaticVoidMethod:procedure(Env:PJNIEnv;AClass:JClass;MethodID:JMethodID);{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      CallStaticVoidMethodV:procedure(Env:PJNIEnv;AClass:JClass;MethodID:JMethodID;Args:va_list);{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      CallStaticVoidMethodA:procedure(Env:PJNIEnv;AClass:JClass;MethodID:JMethodID;Args:PJValue);{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}

      GetStaticFieldID:function(Env:PJNIEnv;AClass:JClass;const Name:pchar;const Sig:pchar):JFieldID;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      GetStaticObjectField:function(Env:PJNIEnv;AClass:JClass;FieldID:JFieldID):JObject;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      GetStaticBooleanField:function(Env:PJNIEnv;AClass:JClass;FieldID:JFieldID):JBoolean;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      GetStaticByteField:function(Env:PJNIEnv;AClass:JClass;FieldID:JFieldID):JByte;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      GetStaticCharField:function(Env:PJNIEnv;AClass:JClass;FieldID:JFieldID):JChar;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      GetStaticShortField:function(Env:PJNIEnv;AClass:JClass;FieldID:JFieldID):JShort;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      GetStaticIntField:function(Env:PJNIEnv;AClass:JClass;FieldID:JFieldID):JInt;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      GetStaticLongField:function(Env:PJNIEnv;AClass:JClass;FieldID:JFieldID):JLong;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      GetStaticFloatField:function(Env:PJNIEnv;AClass:JClass;FieldID:JFieldID):JFloat;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      GetStaticDoubleField:function(Env:PJNIEnv;AClass:JClass;FieldID:JFieldID):JDouble;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}

      SetStaticObjectField:procedure(Env:PJNIEnv;AClass:JClass;FieldID:JFieldID;Val:JObject);{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      SetStaticBooleanField:procedure(Env:PJNIEnv;AClass:JClass;FieldID:JFieldID;Val:JBoolean);{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      SetStaticByteField:procedure(Env:PJNIEnv;AClass:JClass;FieldID:JFieldID;Val:JByte);{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      SetStaticCharField:procedure(Env:PJNIEnv;AClass:JClass;FieldID:JFieldID;Val:JChar);{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      SetStaticShortField:procedure(Env:PJNIEnv;AClass:JClass;FieldID:JFieldID;Val:JShort);{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      SetStaticIntField:procedure(Env:PJNIEnv;AClass:JClass;FieldID:JFieldID;Val:JInt);{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      SetStaticLongField:procedure(Env:PJNIEnv;AClass:JClass;FieldID:JFieldID;Val:JLong);{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      SetStaticFloatField:procedure(Env:PJNIEnv;AClass:JClass;FieldID:JFieldID;Val:JFloat);{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      SetStaticDoubleField:procedure(Env:PJNIEnv;AClass:JClass;FieldID:JFieldID;Val:JDouble);{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}

      NewString:function(Env:PJNIEnv;const Unicode:PJChar;Len:JSize):JString;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      GetStringLength:function(Env:PJNIEnv;Str:JString):JSize;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      GetStringChars:function(Env:PJNIEnv;Str:JString;var IsCopy:JBoolean):PJChar;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      ReleaseStringChars:procedure(Env:PJNIEnv;Str:JString;const Chars:PJChar);{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}

      NewStringUTF:function(Env:PJNIEnv;const UTF:pchar):JString;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      GetStringUTFLength:function(Env:PJNIEnv;Str:JString):JSize;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      GetStringUTFChars:function(Env:PJNIEnv;Str:JString; IsCopy:PJBoolean):pchar;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      ReleaseStringUTFChars:procedure(Env:PJNIEnv;Str:JString;const Chars:pchar);{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}

      GetArrayLength:function(Env:PJNIEnv;AArray:JArray):JSize;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}

      NewObjectArray:function(Env:PJNIEnv;Len:JSize;AClass:JClass;Init:JObject):JObjectArray;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      GetObjectArrayElement:function(Env:PJNIEnv;AArray:JObjectArray;Index:JSize):JObject;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      SetObjectArrayElement:procedure(Env:PJNIEnv;AArray:JObjectArray;Index:JSize;Val:JObject);{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}

      NewBooleanArray:function(Env:PJNIEnv;Len:JSize):JBooleanArray;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      NewByteArray:function(Env:PJNIEnv;Len:JSize):JByteArray;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      NewCharArray:function(Env:PJNIEnv;Len:JSize):JCharArray;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      NewShortArray:function(Env:PJNIEnv;Len:JSize):JShortArray;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      NewIntArray:function(Env:PJNIEnv;Len:JSize):JIntArray;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      NewLongArray:function(Env:PJNIEnv;Len:JSize):JLongArray;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      NewFloatArray:function(Env:PJNIEnv;Len:JSize):JFloatArray;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      NewDoubleArray:function(Env:PJNIEnv;Len:JSize):JDoubleArray;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}

      GetBooleanArrayElements:function(Env:PJNIEnv;AArray:JBooleanArray;var IsCopy:JBoolean):PJBoolean;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      GetByteArrayElements:function(Env:PJNIEnv;AArray:JByteArray;var IsCopy:JBoolean):PJByte;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      GetCharArrayElements:function(Env:PJNIEnv;AArray:JCharArray;var IsCopy:JBoolean):PJChar;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      GetShortArrayElements:function(Env:PJNIEnv;AArray:JShortArray;var IsCopy:JBoolean):PJShort;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      GetIntArrayElements:function(Env:PJNIEnv;AArray:JIntArray;var IsCopy:JBoolean):PJInt;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      GetLongArrayElements:function(Env:PJNIEnv;AArray:JLongArray;var IsCopy:JBoolean):PJLong;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      GetFloatArrayElements:function(Env:PJNIEnv;AArray:JFloatArray;var IsCopy:JBoolean):PJFloat;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      GetDoubleArrayElements:function(Env:PJNIEnv;AArray:JDoubleArray;var IsCopy:JBoolean):PJDouble;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}

      ReleaseBooleanArrayElements:procedure(Env:PJNIEnv;AArray:JBooleanArray;Elems:PJBoolean;Mode:JInt);{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      ReleaseByteArrayElements:procedure(Env:PJNIEnv;AArray:JByteArray;Elems:PJByte;Mode:JInt);{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      ReleaseCharArrayElements:procedure(Env:PJNIEnv;AArray:JCharArray;Elems:PJChar;Mode:JInt);{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      ReleaseShortArrayElements:procedure(Env:PJNIEnv;AArray:JShortArray;Elems:PJShort;Mode:JInt);{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      ReleaseIntArrayElements:procedure(Env:PJNIEnv;AArray:JIntArray;Elems:PJInt;Mode:JInt);{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      ReleaseLongArrayElements:procedure(Env:PJNIEnv;AArray:JLongArray;Elems:PJLong;Mode:JInt);{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      ReleaseFloatArrayElements:procedure(Env:PJNIEnv;AArray:JFloatArray;Elems:PJFloat;Mode:JInt);{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      ReleaseDoubleArrayElements:procedure(Env:PJNIEnv;AArray:JDoubleArray;Elems:PJDouble;Mode:JInt);{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}

      GetBooleanArrayRegion:procedure(Env:PJNIEnv;AArray:JBooleanArray;Start:JSize;Len:JSize;Buf:PJBoolean);{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      GetByteArrayRegion:procedure(Env:PJNIEnv;AArray:JByteArray;Start:JSize;Len:JSize;Buf:PJByte);{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      GetCharArrayRegion:procedure(Env:PJNIEnv;AArray:JCharArray;Start:JSize;Len:JSize;Buf:PJChar);{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      GetShortArrayRegion:procedure(Env:PJNIEnv;AArray:JShortArray;Start:JSize;Len:JSize;Buf:PJShort);{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      GetIntArrayRegion:procedure(Env:PJNIEnv;AArray:JIntArray;Start:JSize;Len:JSize;Buf:PJInt);{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      GetLongArrayRegion:procedure(Env:PJNIEnv;AArray:JLongArray;Start:JSize;Len:JSize;Buf:PJLong);{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      GetFloatArrayRegion:procedure(Env:PJNIEnv;AArray:JFloatArray;Start:JSize;Len:JSize;Buf:PJFloat);{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      GetDoubleArrayRegion:procedure(Env:PJNIEnv;AArray:JDoubleArray;Start:JSize;Len:JSize;Buf:PJDouble);{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}

      SetBooleanArrayRegion:procedure(Env:PJNIEnv;AArray:JBooleanArray;Start:JSize;Len:JSize;Buf:PJBoolean);{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      SetByteArrayRegion:procedure(Env:PJNIEnv;AArray:JByteArray;Start:JSize;Len:JSize;Buf:PJByte);{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      SetCharArrayRegion:procedure(Env:PJNIEnv;AArray:JCharArray;Start:JSize;Len:JSize;Buf:PJChar);{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      SetShortArrayRegion:procedure(Env:PJNIEnv;AArray:JShortArray;Start:JSize;Len:JSize;Buf:PJShort);{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      SetIntArrayRegion:procedure(Env:PJNIEnv;AArray:JIntArray;Start:JSize;Len:JSize;Buf:PJInt);{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      SetLongArrayRegion:procedure(Env:PJNIEnv;AArray:JLongArray;Start:JSize;Len:JSize;Buf:PJLong);{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      SetFloatArrayRegion:procedure(Env:PJNIEnv;AArray:JFloatArray;Start:JSize;Len:JSize;Buf:PJFloat);{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      SetDoubleArrayRegion:procedure(Env:PJNIEnv;AArray:JDoubleArray;Start:JSize;Len:JSize;Buf:PJDouble);{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}

      RegisterNatives:function(Env:PJNIEnv;AClass:JClass;const Methods:PJNINativeMethod;NMethods:JInt):JInt;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      UnregisterNatives:function(Env:PJNIEnv;AClass:JClass):JInt;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}

      MonitorEnter:function(Env:PJNIEnv;Obj:JObject):JInt;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      MonitorExit:function(Env:PJNIEnv;Obj:JObject):JInt;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}

      GetJavaVM:function(Env:PJNIEnv;var VM:JavaVM):JInt;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}

      // String Operations
      GetStringRegion:procedure(Env:PJNIEnv;Str:JString;Start:JSize;Len:JSize;Buf:PJChar);{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      GetStringUTFRegion:procedure(Env:PJNIEnv;Str:JString;Start:JSize;Len:JSize;Buf:pchar);{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}

      // Array Operations
      GetPrimitiveArrayCritical:function(Env:PJNIEnv;AArray:JArray;var IsCopy:JBoolean):pointer;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      ReleasePrimitiveArrayCritical:procedure(Env:PJNIEnv;AArray:JArray;CArray:pointer;Mode:JInt);{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}

      // String Operations
      GetStringCritical:function(Env:PJNIEnv;Str:JString;var IsCopy:JBoolean):PJChar;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      ReleaseStringCritical:procedure(Env:PJNIEnv;Str:JString;CString:PJChar);{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}

      // Weak Global References
      NewWeakGlobalRef:function(Env:PJNIEnv;Obj:JObject):JWeak;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      DeleteWeakGlobalRef:procedure(Env:PJNIEnv;Ref:JWeak);{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}

      // Exceptions
      ExceptionCheck:function(Env:PJNIEnv):JBoolean;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}

      // J2SDK1_4
      NewDirectByteBuffer:function(Env:PJNIEnv;Address:pointer;Capacity:JLong):JObject;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      GetDirectBufferAddress:function(Env:PJNIEnv;Buf:JObject):pointer;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      GetDirectBufferCapacity:function(Env:PJNIEnv;Buf:JObject):JLong;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}

      // added in JNI 1.6
      GetObjectRefType:function(Env:PJNIEnv;AObject:JObject):jobjectRefType;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
     end;

     JNIInvokeInterface={$ifdef packedrecords}packed{$endif} record
      reserved0:pointer;
      reserved1:pointer;
      reserved2:pointer;

      DestroyJavaVM:function(PVM:PJavaVM):JInt;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      AttachCurrentThread:function(PVM:PJavaVM;PEnv:PPJNIEnv;Args:pointer):JInt;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      DetachCurrentThread:function(PVM:PJavaVM):JInt;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      GetEnv:function(PVM:PJavaVM;PEnv:Ppointer;Version:JInt):JInt;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
      AttachCurrentThreadAsDaemon:function(PVM:PJavaVM;PEnv:PPJNIEnv;Args:pointer):JInt;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
     end;

     JavaVMAttachArgs={$ifdef packedrecords}packed{$endif} record
      version:jint;  // must be >= JNI_VERSION_1_2
      name:pchar;    // NULL or name of thread as modified UTF-8 str
      group:jobject; // global ref of a ThreadGroup object, or NULL
     end;

(**
 * JNI 1.2+ initialization.  (As of 1.6, the pre-1.2 structures are no
 * longer supported.)
 *)

     PJavaVMOption=^JavaVMOption;
     JavaVMOption={$ifdef packedrecords}packed{$endif} record
      optionString:pchar;
      extraInfo:pointer;
     end;

     JavaVMInitArgs={$ifdef packedrecords}packed{$endif} record
      version:jint; // use JNI_VERSION_1_2 or later
      nOptions:jint;
      options:PJavaVMOption;
      ignoreUnrecognized:Pjboolean;
     end;

     // Types for jni_func or jni_proc

     TDynArrayOfJByte = array of JByte;

(*
 * VM initialization functions.
 *
 * Note these are the only symbols exported for JNI by the VM.
 *)
{$ifdef jniexternals}
function JNI_GetDefaultJavaVMInitArgs(p:pointer):jint;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}external 'jni' name 'JNI_GetDefaultJavaVMInitArgs';
function JNI_CreateJavaVM(vm:PPJavaVM;AEnv:PPJNIEnv;p:pointer):jint;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}external 'jni' name 'JNI_CreateJavaVM';
function JNI_GetCreatedJavaVMs(vm:PPJavaVM;ASize:jsize;p:Pjsize):jint;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}external 'jni' name 'JNI_GetCreatedJavaVMs';
{$endif}

(*
 * Prototypes for functions exported by loadable shared libs.  These are
 * called by JNI, not provided by JNI.
 *)

 (*

const curVM:PJavaVM=nil;
      curEnv:PJNIEnv=nil;
   *)
(*
function JNI_OnLoad(vm:PJavaVM;reserved:pointer):jint;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
procedure JNI_OnUnload(vm:PJavaVM;reserved:pointer);{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
*)

function JBool( Bool : Boolean ) : byte;

(*
 Abbreviation for variable types for "jni_func" or "jni_proc"

 z:jboolean);
 b:jbyte);
 c:jchar);
 s:jshort);
 i:jint);
 j:jlong);
 f:jfloat);
 d:jdouble);
 l:jobject);
 t: String    -> Ljava/lang/String;

 vig: ViewGroup -> Landroid/view/ViewGroup;
 bmp: Bitmap    -> Landroid/graphics/Bitmap;
 int: Intent    -> Landroid/content/Intent;
 uri: Uri       -> Landroid/net/Uri;
 viw: View      -> Landroid/view/View;
 dab: jDynArrayOfJByte -> [B
*)

procedure jni_proc(env: PJNIEnv; _jobject: JObject; javaFuncion : string);
procedure jni_proc_f(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _float: single);
procedure jni_proc_ff(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _float1, _float2: single);
procedure jni_proc_fffffff(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _float1, _float2, _float3, _float4, _float5, _float6, _float7 : single);
procedure jni_proc_i(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _int: integer);
procedure jni_proc_j(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _long: int64);
procedure jni_proc_iiiiii(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _int1, _int2, _int3, _int4, _int5, _int6: integer);
procedure jni_proc_t(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _str: string);
procedure jni_proc_tt(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _str1, _str2: string);
procedure jni_proc_ttz(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _str1, _str2: string; _bool : boolean);
procedure jni_proc_vig(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _viewgroup: jObject);
procedure jni_proc_z(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _bool: boolean);

function jni_func_out_f(env: PJNIEnv; _jobject: JObject; javaFuncion : string): single;
function jni_func_out_i(env: PJNIEnv; _jobject: JObject; javaFuncion : string): integer;
function jni_func_out_j(env: PJNIEnv; _jobject: JObject; javaFuncion : string): longint;
function jni_func_out_d(env: PJNIEnv; _jobject: JObject; javaFuncion : string): double;
function jni_func_out_t(env: PJNIEnv; _jobject: JObject; javaFuncion : string): string;
function jni_func_out_viw(env: PJNIEnv; _jobject: JObject; javaFuncion : string): jObject;
function jni_func_out_z(env: PJNIEnv; _jobject: JObject; javaFuncion : string): boolean;
function jni_func_out_vig(env: PJNIEnv; _jobject: JObject; javaFuncion : string): jObject;

function jni_func_bmp_out_bmp(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _bitmap: JObject): jObject;
function jni_func_bmp_out_i(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _bitmap: jObject): integer;
function jni_func_n_out_bmp(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _intent: jObject): jObject;
function jni_func_t_out_bmp(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _str: string): jObject;
function jni_func_t_out_t(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _str: string): string;
function jni_func_t_out_z(env: PJNIEnv; _jobject:JObject; javaFuncion : string; _str: string): boolean;
function jni_func_uri_out_bmp(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _uri: jObject): jObject;
function jni_func_dab_out_bmp(env: PJNIEnv; _jobject: JObject; javaFuncion : string; var _byteArray: TDynArrayOfJByte): jObject;
function jni_func_dab_z_out_z(env: PJNIEnv; _jobject: JObject; javaFuncion : string; var _byteArray: TDynArrayOfJByte; _bool1: boolean): boolean;
function jni_func_dd_out_t(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _double1, _double2: double): string;
function jni_func_dd_out_f(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _double1, _double2: double): single;
function jni_func_dddd_out_f(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _double1, _double2, _double3, _double4: double): single;
function jni_func_z_out_z(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _bool: boolean): boolean;

function jni_func_i_out_z(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _int: integer): boolean;
function jni_func_i_out_t(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _int: integer): string;
function jni_func_j_out_t(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _long: longint): string;
function jni_func_ii_out_bmp(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _int1, _int2: integer): jObject;
function jni_func_ff_out_bmp(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _float1, _float2: single): jObject;
function jni_func_ffz_out_t(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _float1, _float2: double; _bool: boolean): string;function jni_func_bmp_ff_out_bmp(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _bitmap: jObject; _float1, _float2: single): jObject;
function jni_func_bmp_t_out_dab(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _bitmap: jObject; _str: string): TDynArrayOfJByte;
function jni_func_bmp_t_out_z(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _bitmap: jObject; _str: string) : boolean;
function jni_func_bmp_tt_out_z(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _bitmap: jObject; _str1, _str2: string) : boolean;
function jni_func_tt_out_bmp(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _str1, _str2: string): jObject;
function jni_func_ti_out_bmp(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _str: string; _int: integer): jObject;
function jni_func_ti_out_z(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _str: string; _int: integer): boolean;
function jni_func_tii_out_z(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _str: string; _int1, _int2: integer): boolean;

implementation

(*
function JNI_OnLoad(vm:PJavaVM;reserved:pointer):jint;{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
begin
 curVM:=vm;
 result:=JNI_VERSION_1_6;
end;

procedure JNI_OnUnload(vm:PJavaVM;reserved:pointer);{$ifdef mswindows}stdcall;{$else}cdecl;{$endif}
begin
end;
  *)

function JBool( Bool : Boolean ) : byte;
 begin
  Case Bool of
   True  : Result := 1;
   False : Result := 0;
  End;
 end;

procedure jni_proc(env: PJNIEnv; _jobject: JObject; javaFuncion : string );
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jobject);
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '()V');
  env^.CallVoidMethod(env, _jobject, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jni_proc_f(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                     _float: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _float;

  jCls:= env^.GetObjectClass(env, _jobject);
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(F)V');
  env^.CallVoidMethodA(env, _jobject, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jni_proc_ff(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                     _float1, _float2: single);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _float1;
  jParams[1].f:= _float2;

  jCls:= env^.GetObjectClass(env, _jobject);
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(FF)V');
  env^.CallVoidMethodA(env, _jobject, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jni_proc_fffffff(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                     _float1, _float2, _float3, _float4, _float5, _float6, _float7 : single);
var
  jParams: array[0..6] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _float1;
  jParams[1].f:= _float2;
  jParams[2].f:= _float3;
  jParams[3].f:= _float4;
  jParams[4].f:= _float5;
  jParams[5].f:= _float6;
  jParams[6].f:= _float7;

  jCls:= env^.GetObjectClass(env, _jobject);
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(FFFFFFF)V');
  env^.CallVoidMethodA(env, _jobject, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jni_proc_vig(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                       _viewgroup: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _viewgroup;
  jCls:= env^.GetObjectClass(env, _jobject);
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env, _jobject, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jni_proc_z(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                      _bool: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_bool);

  jCls:= env^.GetObjectClass(env, _jobject);
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Z)V');

  env^.CallVoidMethodA(env, _jobject, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jni_proc_i(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                     _int: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _int;

  jCls:= env^.GetObjectClass(env, _jobject);
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(I)V');
  env^.CallVoidMethodA(env, _jobject, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jni_proc_j(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                     _long: int64);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _long;

  jCls:= env^.GetObjectClass(env, _jobject);
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(J)V');

  env^.CallVoidMethodA(env, _jobject, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jni_proc_iiiiii(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                          _int1, _int2, _int3, _int4, _int5, _int6: integer);
var
  jParams: array[0..5] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _int1;
  jParams[1].i:= _int2;
  jParams[2].i:= _int3;
  jParams[3].i:= _int4;
  jParams[4].i:= _int5;
  jParams[5].i:= _int6;
  jCls:= env^.GetObjectClass(env, _jobject);
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(IIIIII)V');
  env^.CallVoidMethodA(env, _jobject, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jni_proc_t(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                     _str: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_str));
  jCls:= env^.GetObjectClass(env, _jobject);
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jobject, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jni_proc_tt(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                      _str1, _str2: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l := env^.NewStringUTF(env, PChar(_str1));
  jParams[1].l := env^.NewStringUTF(env, PChar(_str2));

  jCls:= env^.GetObjectClass(env, _jobject);
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jni_proc_ttz(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                     _str1, _str2: string; _bool : boolean);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l := env^.NewStringUTF(env, PChar(_str1));
  jParams[1].l := env^.NewStringUTF(env, PChar(_str2));
  jParams[2].z := JBool(_bool);

  jCls:= env^.GetObjectClass(env, _jobject);
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Ljava/lang/String;Ljava/lang/String;Z)V');
  env^.CallVoidMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jni_func_out_f(env: PJNIEnv; _jobject: JObject; javaFuncion : string ): single;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jobject);
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '()F');
  Result:= env^.CallFloatMethod(env, _jobject, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jni_func_out_d(env: PJNIEnv; _jobject: JObject; javaFuncion : string ): double;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jobject);
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '()D');
  Result:= env^.CallDoubleMethod(env, _jobject, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jni_func_out_vig(env: PJNIEnv; _jobject: JObject; javaFuncion : string ): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jobject);
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '()Landroid/view/ViewGroup;');
  Result:= env^.CallObjectMethod(env, _jobject, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jni_func_out_i(env: PJNIEnv; _jobject: JObject; javaFuncion : string ): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jobject);
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '()I');
  Result:= env^.CallIntMethod(env, _jobject, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jni_func_out_j(env: PJNIEnv; _jobject: JObject; javaFuncion : string ): longint;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jobject);
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '()J');
  Result:= env^.CallLongMethod(env, _jobject, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jni_func_out_t(env: PJNIEnv; _jobject: JObject; javaFuncion : string ): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jobject);
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '()Ljava/lang/String;');
  jStr:= env^.CallObjectMethod(env, _jobject, jMethod);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;

function jni_func_out_viw(env: PJNIEnv; _jobject: JObject; javaFuncion : string): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jobject);
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '()Landroid/view/View;');
  Result:= env^.CallObjectMethod(env, _jobject, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jni_func_out_z(env: PJNIEnv; _jobject: JObject; javaFuncion : string): boolean;
var
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jobject);
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '()Z');
  jBoo:= env^.CallBooleanMethod(env, _jobject, jMethod);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);
end;

function jni_func_bmp_out_i(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                          _bitmap: jObject): integer;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _bitmap;

  jCls:= env^.GetObjectClass(env, _jobject);
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Landroid/graphics/Bitmap;)I');
  Result:= env^.CallIntMethodA(env, _jobject, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jni_func_dab_out_bmp(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                          var _byteArray: TDynArrayOfJByte): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
begin
  newSize0:= Length(_byteArray);
  jNewArray0:= env^.NewByteArray(env, newSize0);  // allocate
  env^.SetByteArrayRegion(env, jNewArray0, 0 , newSize0, @_byteArray[0] {source});
  jParams[0].l:= jNewArray0;

  jCls:= env^.GetObjectClass(env, _jobject);
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '([B)Landroid/graphics/Bitmap;');
  Result:= env^.CallObjectMethodA(env, _jobject, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jni_func_dab_z_out_z(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                              var _byteArray: TDynArrayOfJByte; _bool1: boolean): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
begin
  newSize0:= Length(_byteArray);
  jNewArray0:= env^.NewByteArray(env, newSize0);  // allocate
  env^.SetByteArrayRegion(env, jNewArray0, 0 , newSize0, @_byteArray[0] {source});
  jParams[0].l:= jNewArray0;
  jParams[1].z:= JBool(_bool1);

  jCls:= env^.GetObjectClass(env, _jobject);
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '([BZ)Z');
  jBoo:= env^.CallBooleanMethodA(env, _jobject, jMethod, @jParams);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jni_func_dd_out_t(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                            _double1, _double2: double): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].d:= _double1;
  jParams[1].d:= _double2;

  jCls:= env^.GetObjectClass(env, _jobject);
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(DD)Ljava/lang/String;');

  jStr:= env^.CallObjectMethodA(env, _jobject, jMethod, @jParams);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;

function jni_func_dd_out_f(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                           _double1, _double2: double): single;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].d:= _double1;
  jParams[1].d:= _double2;

  jCls:= env^.GetObjectClass(env, _jobject);
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(DD)F');

  Result:= env^.CallFloatMethodA(env, _jobject, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jni_func_dddd_out_f(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                             _double1, _double2, _double3, _double4: double): single;
var
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].d:= _double1;
  jParams[1].d:= _double2;
  jParams[2].d:= _double3;
  jParams[3].d:= _double4;

  jCls:= env^.GetObjectClass(env, _jobject);
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(DDDD)F');

  Result:= env^.CallFloatMethodA(env, _jobject, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jni_func_z_out_z(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                          _bool: boolean): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_bool);

  jCls:= env^.GetObjectClass(env, _jobject);
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Z)Z');
  jBoo:= env^.CallBooleanMethodA(env, _jobject, jMethod, @jParams);

  Result:= boolean(jBoo);

  env^.DeleteLocalRef(env, jCls);
end;

function jni_func_bmp_out_bmp(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                          _bitmap: JObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _bitmap;

  jCls:= env^.GetObjectClass(env, _jobject);
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Landroid/graphics/Bitmap;)Landroid/graphics/Bitmap;');
  Result:= env^.CallObjectMethodA(env, _jobject, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jni_func_t_out_bmp(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                            _str: string): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_str));

  jCls:= env^.GetObjectClass(env, _jobject);
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Ljava/lang/String;)Landroid/graphics/Bitmap;');
  Result:= env^.CallObjectMethodA(env, _jobject, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jni_func_uri_out_bmp(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                              _uri: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _uri;

  jCls:= env^.GetObjectClass(env, _jobject);
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Landroid/net/Uri;)Landroid/graphics/Bitmap;');
  Result:= env^.CallObjectMethodA(env, _jobject, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jni_func_n_out_bmp(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                            _intent: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _intent;

  jCls:= env^.GetObjectClass(env, _jobject);
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Landroid/content/Intent;)Landroid/graphics/Bitmap;');
  Result:= env^.CallObjectMethodA(env, _jobject, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jni_func_i_out_t(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                          _int: integer): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _int;

  jCls:= env^.GetObjectClass(env, _jobject);
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(I)Ljava/lang/String;');

  jStr:= env^.CallObjectMethodA(env, _jobject, jMethod, @jParams);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;

function jni_func_j_out_t(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                          _long: longint): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _long;

  jCls:= env^.GetObjectClass(env, _jobject);
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(J)Ljava/lang/String;');

  jStr:= env^.CallObjectMethodA(env, _jobject, jMethod, @jParams);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;

function jni_func_i_out_z(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                          _int: integer): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _int;

  jCls:= env^.GetObjectClass(env, _jobject);
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(I)Z');
  jBoo:= env^.CallBooleanMethodA(env, _jobject, jMethod, @jParams);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);
end;

function jni_func_ii_out_bmp(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                             _int1, _int2: integer): jObject;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _int1;
  jParams[1].i:= _int2;

  jCls:= env^.GetObjectClass(env, _jobject);
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(II)Landroid/graphics/Bitmap;');
  Result:= env^.CallObjectMethodA(env, _jobject, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jni_func_tt_out_bmp(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                           _str1, _str2: string): jObject;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_str1));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_str2));

  jCls:= env^.GetObjectClass(env, _jobject);
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Ljava/lang/String;Ljava/lang/String;)Landroid/graphics/Bitmap;');
  Result:= env^.CallObjectMethodA(env, _jobject, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jni_func_ti_out_bmp(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                             _str: string; _int: integer): jObject;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_str));
  jParams[1].i:= _int;
  jCls:= env^.GetObjectClass(env, _jobject);
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Ljava/lang/String;I)Landroid/graphics/Bitmap;');
  Result:= env^.CallObjectMethodA(env, _jobject, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jni_func_ti_out_z(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                            _str: string; _int: integer): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_str));
  jParams[1].i:= _int;

  jCls:= env^.GetObjectClass(env, _jobject);
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Ljava/lang/String;I)Z');
  jBoo:= env^.CallBooleanMethodA(env, _jobject, jMethod, @jParams);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jni_func_tii_out_z(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                            _str: string; _int1, _int2: integer): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_str));
  jParams[1].i:= _int1;
  jParams[2].i:= _int2;

  jCls:= env^.GetObjectClass(env, _jobject);
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Ljava/lang/String;II)Z');
  jBoo:= env^.CallBooleanMethodA(env, _jobject, jMethod, @jParams);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jni_func_bmp_t_out_z(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                           _bitmap: jObject; _str: string) : boolean;
var
  jBoo: JBoolean;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _bitmap;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_str));

  jCls    := env^.GetObjectClass(env, _jobject);
  jMethod := env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Landroid/graphics/Bitmap;Ljava/lang/String;)Z');
  jBoo    := env^.CallBooleanMethodA(env, _jobject, jMethod, @jParams);
  Result  := boolean(jBoo);

  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jni_func_bmp_tt_out_z(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                           _bitmap: jObject; _str1, _str2: string) : boolean;
var
  jBoo: JBoolean;
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _bitmap;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_str1));
  jParams[2].l:= env^.NewStringUTF(env, PChar(_str2));

  jCls    := env^.GetObjectClass(env, _jobject);
  jMethod := env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Landroid/graphics/Bitmap;Ljava/lang/String;Ljava/lang/String;)Z');
  jBoo    := env^.CallBooleanMethodA(env, _jobject, jMethod, @jParams);
  Result  := boolean(jBoo);

  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jni_func_ff_out_bmp(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                             _float1, _float2: single): jObject;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _float1;
  jParams[1].f:= _float2;

  jCls:= env^.GetObjectClass(env, _jobject);
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(FF)Landroid/graphics/Bitmap;');
  Result:= env^.CallObjectMethodA(env, _jobject, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jni_func_ffz_out_t(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                             _float1, _float2: double; _bool: boolean): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].d:= _float1;
  jParams[1].d:= _float2;
  jParams[2].z:= JBool(_bool);

  jCls:= env^.GetObjectClass(env, _jobject);
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(DDZ)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jobject, jMethod, @jParams);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;

function jni_func_bmp_ff_out_bmp(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                                 _bitmap: jObject; _float1, _float2: single): jObject;
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _bitmap;
  jParams[1].f:= _float1;
  jParams[2].f:= _float2;

  jCls:= env^.GetObjectClass(env, _jobject);
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Landroid/graphics/Bitmap;FF)Landroid/graphics/Bitmap;');
  Result:= env^.CallObjectMethodA(env, _jobject, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jni_func_t_out_t( env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                          _str: string): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_str));

  jCls:= env^.GetObjectClass(env, _jobject);
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Ljava/lang/String;)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jobject, jMethod, @jParams);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jni_func_t_out_z(env: PJNIEnv; _jobject:JObject; javaFuncion : string;
                          _str: string): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_str));

  jCls:= env^.GetObjectClass(env, _jobject);
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Ljava/lang/String;)Z');
  jBoo:= env^.CallBooleanMethodA(env, _jobject, jMethod, @jParams);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jni_func_bmp_t_out_dab(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                                _bitmap: jObject; _str: string): TDynArrayOfJByte;
var
  resultSize: integer;
  jResultArray: jObject;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _bitmap;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_str));

  jCls:= env^.GetObjectClass(env, _jobject);
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Landroid/graphics/Bitmap;Ljava/lang/String;)[B');
  jResultArray:= env^.CallObjectMethodA(env, _jobject, jMethod,  @jParams);
  if jResultArray <> nil then
  begin
    resultSize:= env^.GetArrayLength(env, jResultArray);
    SetLength(Result, resultSize);
    env^.GetByteArrayRegion(env, jResultArray, 0, resultSize, @Result[0] {target});
  end;
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

end.


