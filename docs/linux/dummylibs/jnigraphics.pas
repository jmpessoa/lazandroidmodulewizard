library jnigraphics;

  function AndroidBitmap_getInfo(env: pointer; jbitmap: pointer; info: pointer): longint;
                                     cdecl;
  begin
  end;

  function AndroidBitmap_lockPixels(env: pointer; jbitmap: pointer; addrPtr: pointer {void**}): longint;
                                     cdecl;
  begin
  end;

  function AndroidBitmap_unlockPixels(env: pointer; jbitmap: pointer): longint;
                                     cdecl;
  begin
  end;

  procedure glFrustumf(left,right,bottom,top,near,far: Single); cdecl;
  begin
  end;
  
exports
  AndroidBitmap_getInfo,
  AndroidBitmap_lockPixels,
  AndroidBitmap_unlockPixels,
  glFrustumf; // this shouldn't be here, but I have no idea where else to put

end.
