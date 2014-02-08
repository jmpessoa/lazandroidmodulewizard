library log;

  function __android_log_write(prio:longint; tag,text: pchar):longint; cdecl;
  begin
  end;

exports
  __android_log_write;
  
end.
