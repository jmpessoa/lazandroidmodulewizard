unit And_log;

interface

uses
 And_log_h;

procedure log(msg: pchar);

implementation

procedure log(msg: pchar);
begin
   __android_log_write(ANDROID_LOG_FATAL,'crap',msg);
end;

end.
