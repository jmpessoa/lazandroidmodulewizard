
{* 
 * Open source license agreement: Lazarus Modified LGPL 
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *}

unit And_bitmap_h;

   (*Modified by Stephano [14-04-2014]: "I saw Leledumbo's post and the readme file. The 2 solutions that I proposed are much cleaner and don't
     require any extra steps from the user."
    ref. http://forum.lazarus.freepascal.org/index.php/topic,21919.105.html *)

{$mode delphi}
{$packrecords c}

interface

uses
  ctypes, And_jni;

{#include <stdint.h>
#include <jni.h>}

const

  libjnigraphics ='libjnigraphics.so';

  ANDROID_BITMAP_RESUT_SUCCESS            = 0;
  ANDROID_BITMAP_RESULT_BAD_PARAMETER     =-1;
  ANDROID_BITMAP_RESULT_JNI_EXCEPTION     =-2;
  ANDROID_BITMAP_RESULT_ALLOCATION_FAILED =-3;

type

  AndroidBitmapFormat = (
    ANDROID_BITMAP_FORMAT_NONE      = 0,
    ANDROID_BITMAP_FORMAT_RGBA_8888 = 1,
    ANDROID_BITMAP_FORMAT_RGB_565   = 4,
    ANDROID_BITMAP_FORMAT_RGBA_4444 = 7,
    ANDROID_BITMAP_FORMAT_A_8       = 8
  );

  AndroidBitmapInfo = record
    width: Cardinal;//uint32_t;
    height: Cardinal;//uint32_t
    stride: Cardinal;//uint32_t
    format: Integer;//int32_t
    flags: Cardinal;//uint32_t      // 0 for now
  end;
  PAndroidBitmapInfo = ^AndroidBitmapInfo;

  // jnigraphics
  function AndroidBitmap_getInfo(env: PJNIEnv; jbitmap: jobject; info: PAndroidBitmapInfo): cint;
                                     {$IFDEF android}cdecl; external libjnigraphics name 'AndroidBitmap_getInfo';{$ENDIF}

 function AndroidBitmap_lockPixels(env: PJNIEnv; jbitmap: jobject; addrPtr: PPointer {void**}): cint;
                                     {$IFDEF android}cdecl; external libjnigraphics name 'AndroidBitmap_lockPixels';{$ENDIF}

  function AndroidBitmap_unlockPixels(env: PJNIEnv; jbitmap: jobject): cint;
                                     {$IFDEF android}cdecl; external libjnigraphics name 'AndroidBitmap_unlockPixels';{$ENDIF}

implementation

{$IFnDEF android}
function AndroidBitmap_getInfo(env: PJNIEnv; jbitmap: jobject;
  info: PAndroidBitmapInfo): cint;
begin
  Result := 0;
end;

function AndroidBitmap_lockPixels(env: PJNIEnv; jbitmap: jobject;
  addrPtr: PPointer): cint;
begin
  Result := 0;
end;

function AndroidBitmap_unlockPixels(env: PJNIEnv; jbitmap: jobject): cint;
begin
  Result := 0;
end;
{$ENDIF}

end.
