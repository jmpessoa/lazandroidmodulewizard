{* 
 * Open source license agreement: Lazarus Modified LGPL 
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *}

unit And_log_h;


   (*Modified by Stephano [14-04-2014]: "I saw Leledumbo's post and the readme file.
     The 2 solutions that I proposed are much cleaner and don't
     require any extra steps from the user."
    ref. http://forum.lazarus.freepascal.org/index.php/topic,21919.105.html *)

{$ifdef fpc}
 {$mode delphi}
{$endif}

interface

const

      libname='liblog.so';  

      ANDROID_LOG_UNKNOWN=0;
      ANDROID_LOG_DEFAULT=1;
      ANDROID_LOG_VERBOSE=2;
      ANDROID_LOG_DEBUG=3;
      ANDROID_LOG_INFO=4;
      ANDROID_LOG_WARN=5;
      ANDROID_LOG_ERROR=6;
      ANDROID_LOG_FATAL=7;
      ANDROID_LOG_SILENT=8;

type    

  android_LogPriority=integer;

  function __android_log_write(prio:longint; tag,text: pchar):longint;
            {$IFDEF android}cdecl; external libname name '__android_log_write';{$ENDIF}    

  function LOGI(prio:longint;tag,text:pchar):longint;
            {$IFDEF android}cdecl; varargs; external libname name '__android_log_print';{$ENDIF} 

  //function __android_log_print(prio:longint;tag,print:pchar;params:array of pchar):longint;
            //{$IFDEF android}cdecl; external libname name '__android_log_print';{$ENDIF}

implementation

{$IFnDEF android}
function __android_log_write(prio: longint; tag, text: pchar): longint;
begin
  Result := 0;
end;

function LOGI(prio: longint; tag, text: pchar): longint;
begin
  Result := 0;
end;
{$ENDIF}

end.
