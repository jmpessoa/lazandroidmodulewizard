unit Laz_And_GLESv2_Canvas_h;

{$mode delphi}

interface

     
const
   //libname = 'libGLESv2.so';

   (* by Leledumbo for Linux users:
       1. Build all libraries in the  ../LazAndroidWizard/linux/dummylibs
       2. Put it somewhere ldconfig can find (or just run ldconfig with their directories as arguments)

       "The idea of this is just to make the package installable in the IDE,
       applications will still use the android version of the libraries."

       ref. http://forum.lazarus.freepascal.org/index.php/topic,21919.msg137216/topicseen.html
   *)

libname = {$ifdef linux}'libGL.so'{$else}'libGLESv2.so'{$endif};

Type
  khronos_int8_t                         = ShortInt;
  khronos_float_t                        = Single;
  khronos_int32_t                        = Integer;
  khronos_intptr_t                       = ^Integer;
  khronos_ssize_t                        = Integer;
  khronos_uint8_t                        = Byte;

  // Base Type for Conversion
  Ppointer                                = ^pointer;
  PPchar                                  = ^Pchar;

  GLbitfield                              = LongWord;
  PGLbitfield                             = ^GLbitfield;
  GLboolean                               = byte;
  PGLboolean                              = ^GLboolean;
  GLbyte                                  = khronos_int8_t;
  PGLbyte                                 = ^GLbyte;
  GLclampf                                = khronos_float_t;
  PGLclampf                               = ^GLclampf;
  GLenum                                  = LongWord;
  PGLenum                                 = ^GLenum;
  GLfixed                                 = khronos_int32_t;
  PGLfixed                                = ^GLfixed;
  GLfloat                                 = khronos_float_t;
  PGLfloat                                = ^GLfloat;
  GLint                                   = LongInt;
  PGLint                                  = ^GLint;
  GLintptr                                = khronos_intptr_t;
  PGLintptr                               = ^GLintptr;
  GLshort                                 = smallint;
  PGLshort                                = ^GLshort;
  GLsizei                                 = LongInt;
  PGLsizei                                = ^GLsizei;
  GLsizeiptr                              = khronos_ssize_t;
  PGLsizeiptr                             = ^GLsizeiptr;
  GLubyte                                 = khronos_uint8_t;
  PGLubyte                                = ^GLubyte;
  GLuint                                  = LongWord;
  PGLuint                                 = ^GLuint;
  GLushort                                = word;
  PGLushort                               = ^GLushort;
  GLvoid                                  = pointer;
  PGLvoid                                 = ^GLvoid;    


const
  GL_ES_VERSION_2_0                       = 1;        // OpenGL ES core versions
  GL_DEPTH_BUFFER_BIT                     = $00000100;// ClearBufferMask
  GL_STENCIL_BUFFER_BIT                   = $00000400;
  GL_COLOR_BUFFER_BIT                     = $00004000;
  // Boolean
  GL_FALSE                                = 0;
  GL_TRUE                                 = 1;
  // BeginMode
  GL_POINTS                               = $0000;
  GL_LINES                                = $0001;
  GL_LINE_LOOP                            = $0002;
  GL_LINE_STRIP                           = $0003;
  GL_TRIANGLES                            = $0004;
  GL_TRIANGLE_STRIP                       = $0005;
  GL_TRIANGLE_FAN                         = $0006;
  // AlphaFunction (not supported in ES20)
  //     GL_NEVER
  //     GL_LESS
  //     GL_EQUAL
  //     GL_LEQUAL
  //     GL_GREATER
  //     GL_NOTEQUAL
  //     GL_GEQUAL
  //     GL_ALWAYS
  // BlendingFactorDest
  GL_ZERO                                 = 0;
  GL_ONE                                  = 1;
  GL_SRC_COLOR                            = $0300;
  GL_ONE_MINUS_SRC_COLOR                  = $0301;
  GL_SRC_ALPHA                            = $0302;
  GL_ONE_MINUS_SRC_ALPHA                  = $0303;
  GL_DST_ALPHA                            = $0304;
  GL_ONE_MINUS_DST_ALPHA                  = $0305;
  // BlendingFactorSrc
  //     GL_ZERO
  //     GL_ONE
  GL_DST_COLOR                            = $0306;
  GL_ONE_MINUS_DST_COLOR                  = $0307;
  GL_SRC_ALPHA_SATURATE                   = $0308;
  //     GL_SRC_ALPHA
  //     GL_ONE_MINUS_SRC_ALPHA
  //     GL_DST_ALPHA
  //     GL_ONE_MINUS_DST_ALPHA
  //  BlendEquationSeparate
  GL_FUNC_ADD                             = $8006;
  GL_BLEND_EQUATION                       = $8009;
  GL_BLEND_EQUATION_RGB                   = GL_BLEND_EQUATION;
  GL_BLEND_EQUATION_ALPHA                 = $883D;
  // BlendSubtract
  GL_FUNC_SUBTRACT                        = $800A;
  GL_FUNC_REVERSE_SUBTRACT                = $800B;
  // Separate Blend Functions
  GL_BLEND_DST_RGB                        = $80C8;
  GL_BLEND_SRC_RGB                        = $80C9;
  GL_BLEND_DST_ALPHA                      = $80CA;
  GL_BLEND_SRC_ALPHA                      = $80CB;
  GL_CONSTANT_COLOR                       = $8001;
  GL_ONE_MINUS_CONSTANT_COLOR             = $8002;
  GL_CONSTANT_ALPHA                       = $8003;
  GL_ONE_MINUS_CONSTANT_ALPHA             = $8004;
  GL_BLEND_COLOR                          = $8005;
  // Buffer Objects
  GL_ARRAY_BUFFER                         = $8892;
  GL_ELEMENT_ARRAY_BUFFER                 = $8893;
  GL_ARRAY_BUFFER_BINDING                 = $8894;
  GL_ELEMENT_ARRAY_BUFFER_BINDING         = $8895;
  GL_STREAM_DRAW                          = $88E0;
  GL_STATIC_DRAW                          = $88E4;
  GL_DYNAMIC_DRAW                         = $88E8;
  GL_BUFFER_SIZE                          = $8764;
  GL_BUFFER_USAGE                         = $8765;
  GL_CURRENT_VERTEX_ATTRIB                = $8626;
  // CullFaceMode
  GL_FRONT                                = $0404;
  GL_BACK                                 = $0405;
  GL_FRONT_AND_BACK                       = $0408;
  // DepthFunction
  //      GL_NEVER
  //      GL_LESS
  //      GL_EQUAL
  //      GL_LEQUAL
  //      GL_GREATER
  //      GL_NOTEQUAL
  //      GL_GEQUAL
  //      GL_ALWAYS
  { EnableCap  }
  GL_TEXTURE_2D                           = $0DE1;
  GL_CULL_FACE                            = $0B44;
  GL_BLEND                                = $0BE2;
  GL_DITHER                               = $0BD0;
  GL_STENCIL_TEST                         = $0B90;
  GL_DEPTH_TEST                           = $0B71;
  GL_SCISSOR_TEST                         = $0C11;
  GL_POLYGON_OFFSET_FILL                  = $8037;
  GL_SAMPLE_ALPHA_TO_COVERAGE             = $809E;
  GL_SAMPLE_COVERAGE                      = $80A0;
  { ErrorCode  }
  GL_NO_ERROR                             = 0;
  GL_INVALID_ENUM                         = $0500;
  GL_INVALID_VALUE                        = $0501;
  GL_INVALID_OPERATION                    = $0502;
  GL_OUT_OF_MEMORY                        = $0505;
  { FrontFaceDirection  }
  GL_CW                                   = $0900;
  GL_CCW                                  = $0901;
  { GetPName  }
  GL_LINE_WIDTH                           = $0B21;
  GL_ALIASED_POINT_SIZE_RANGE             = $846D;
  GL_ALIASED_LINE_WIDTH_RANGE             = $846E;
  GL_CULL_FACE_MODE                       = $0B45;
  GL_FRONT_FACE                           = $0B46;
  GL_DEPTH_RANGE                          = $0B70;
  GL_DEPTH_WRITEMASK                      = $0B72;
  GL_DEPTH_CLEAR_VALUE                    = $0B73;
  GL_DEPTH_FUNC                           = $0B74;
  GL_STENCIL_CLEAR_VALUE                  = $0B91;
  GL_STENCIL_FUNC                         = $0B92;
  GL_STENCIL_FAIL                         = $0B94;
  GL_STENCIL_PASS_DEPTH_FAIL              = $0B95;
  GL_STENCIL_PASS_DEPTH_PASS              = $0B96;
  GL_STENCIL_REF                          = $0B97;
  GL_STENCIL_VALUE_MASK                   = $0B93;
  GL_STENCIL_WRITEMASK                    = $0B98;
  GL_STENCIL_BACK_FUNC                    = $8800;
  GL_STENCIL_BACK_FAIL                    = $8801;
  GL_STENCIL_BACK_PASS_DEPTH_FAIL         = $8802;
  GL_STENCIL_BACK_PASS_DEPTH_PASS         = $8803;
  GL_STENCIL_BACK_REF                     = $8CA3;
  GL_STENCIL_BACK_VALUE_MASK              = $8CA4;
  GL_STENCIL_BACK_WRITEMASK               = $8CA5;
  GL_VIEWPORT                             = $0BA2;
  GL_SCISSOR_BOX                          = $0C10;
  //      GL_SCISSOR_TEST
  GL_COLOR_CLEAR_VALUE                    = $0C22;
  GL_COLOR_WRITEMASK                      = $0C23;
  GL_UNPACK_ALIGNMENT                     = $0CF5;
  GL_PACK_ALIGNMENT                       = $0D05;
  GL_MAX_TEXTURE_SIZE                     = $0D33;
  GL_MAX_VIEWPORT_DIMS                    = $0D3A;
  GL_SUBPIXEL_BITS                        = $0D50;
  GL_RED_BITS                             = $0D52;
  GL_GREEN_BITS                           = $0D53;
  GL_BLUE_BITS                            = $0D54;
  GL_ALPHA_BITS                           = $0D55;
  GL_DEPTH_BITS                           = $0D56;
  GL_STENCIL_BITS                         = $0D57;
  GL_POLYGON_OFFSET_UNITS                 = $2A00;
  //      GL_POLYGON_OFFSET_FILL
  GL_POLYGON_OFFSET_FACTOR                = $8038;
  GL_TEXTURE_BINDING_2D                   = $8069;
  GL_SAMPLE_BUFFERS                       = $80A8;
  GL_SAMPLES                              = $80A9;
  GL_SAMPLE_COVERAGE_VALUE                = $80AA;
  GL_SAMPLE_COVERAGE_INVERT               = $80AB;
  // GetTextureParameter
  //      GL_TEXTURE_MAG_FILTER
  //      GL_TEXTURE_MIN_FILTER
  //      GL_TEXTURE_WRAP_S
  //      GL_TEXTURE_WRAP_T
  GL_NUM_COMPRESSED_TEXTURE_FORMATS       = $86A2;
  GL_COMPRESSED_TEXTURE_FORMATS           = $86A3;
  // HintMode
  GL_DONT_CARE                            = $1100;
  GL_FASTEST                              = $1101;
  GL_NICEST                               = $1102;
  // HintTarget
  GL_GENERATE_MIPMAP_HINT                 = $8192;
  // DataType
  GL_BYTE                                 = $1400;
  GL_UNSIGNED_BYTE                        = $1401;
  GL_SHORT                                = $1402;
  GL_UNSIGNED_SHORT                       = $1403;
  GL_INT                                  = $1404;
  GL_UNSIGNED_INT                         = $1405;
  GL_FLOAT                                = $1406;
  GL_FIXED                                = $140C;
  { PixelFormat  }
  GL_DEPTH_COMPONENT                      = $1902;
  GL_ALPHA                                = $1906;
  GL_RGB                                  = $1907;
  GL_RGBA                                 = $1908;
  GL_LUMINANCE                            = $1909;
  GL_LUMINANCE_ALPHA                      = $190A;
  // PixelType
  //      GL_UNSIGNED_BYTE
  GL_UNSIGNED_SHORT_4_4_4_4               = $8033;
  GL_UNSIGNED_SHORT_5_5_5_1               = $8034;
  GL_UNSIGNED_SHORT_5_6_5                 = $8363;
  // Shaders
  GL_FRAGMENT_SHADER                      = $8B30;
  GL_VERTEX_SHADER                        = $8B31;
  GL_MAX_VERTEX_ATTRIBS                   = $8869;
  GL_MAX_VERTEX_UNIFORM_VECTORS           = $8DFB;
  GL_MAX_VARYING_VECTORS                  = $8DFC;
  GL_MAX_COMBINED_TEXTURE_IMAGE_UNITS     = $8B4D;
  GL_MAX_VERTEX_TEXTURE_IMAGE_UNITS       = $8B4C;
  GL_MAX_TEXTURE_IMAGE_UNITS              = $8872;
  GL_MAX_FRAGMENT_UNIFORM_VECTORS         = $8DFD;
  GL_SHADER_TYPE                          = $8B4F;
  GL_DELETE_STATUS                        = $8B80;
  GL_LINK_STATUS                          = $8B82;
  GL_VALIDATE_STATUS                      = $8B83;
  GL_ATTACHED_SHADERS                     = $8B85;
  GL_ACTIVE_UNIFORMS                      = $8B86;
  GL_ACTIVE_UNIFORM_MAX_LENGTH            = $8B87;
  GL_ACTIVE_ATTRIBUTES                    = $8B89;
  GL_ACTIVE_ATTRIBUTE_MAX_LENGTH          = $8B8A;
  GL_SHADING_LANGUAGE_VERSION             = $8B8C;
  GL_CURRENT_PROGRAM                      = $8B8D;
  // StencilFunction
  GL_NEVER                                = $0200;
  GL_LESS                                 = $0201;
  GL_EQUAL                                = $0202;
  GL_LEQUAL                               = $0203;
  GL_GREATER                              = $0204;
  GL_NOTEQUAL                             = $0205;
  GL_GEQUAL                               = $0206;
  GL_ALWAYS                               = $0207;
  // StencilOp
  {      GL_ZERO  }
  GL_KEEP                                 = $1E00;
  GL_REPLACE                              = $1E01;
  GL_INCR                                 = $1E02;
  GL_DECR                                 = $1E03;
  GL_INVERT                               = $150A;
  GL_INCR_WRAP                            = $8507;
  GL_DECR_WRAP                            = $8508;
  { StringName  }
  GL_VENDOR                               = $1F00;
  GL_RENDERER                             = $1F01;
  GL_VERSION                              = $1F02;
  GL_EXTENSIONS                           = $1F03;
  { TextureMagFilter  }
  GL_NEAREST                              = $2600;
  GL_LINEAR                               = $2601;
  { TextureMinFilter  }
  {      GL_NEAREST  }
  {      GL_LINEAR  }
  GL_NEAREST_MIPMAP_NEAREST               = $2700;
  GL_LINEAR_MIPMAP_NEAREST                = $2701;
  GL_NEAREST_MIPMAP_LINEAR                = $2702;
  GL_LINEAR_MIPMAP_LINEAR                 = $2703;
  { TextureParameterName  }
  GL_TEXTURE_MAG_FILTER                   = $2800;
  GL_TEXTURE_MIN_FILTER                   = $2801;
  GL_TEXTURE_WRAP_S                       = $2802;
  GL_TEXTURE_WRAP_T                       = $2803;
  { TextureTarget  }
  {      GL_TEXTURE_2D  }
  GL_TEXTURE                              = $1702;
  GL_TEXTURE_CUBE_MAP                     = $8513;
  GL_TEXTURE_BINDING_CUBE_MAP             = $8514;
  GL_TEXTURE_CUBE_MAP_POSITIVE_X          = $8515;
  GL_TEXTURE_CUBE_MAP_NEGATIVE_X          = $8516;
  GL_TEXTURE_CUBE_MAP_POSITIVE_Y          = $8517;
  GL_TEXTURE_CUBE_MAP_NEGATIVE_Y          = $8518;
  GL_TEXTURE_CUBE_MAP_POSITIVE_Z          = $8519;
  GL_TEXTURE_CUBE_MAP_NEGATIVE_Z          = $851A;
  GL_MAX_CUBE_MAP_TEXTURE_SIZE            = $851C;
  { TextureUnit  }
  GL_TEXTURE0                             = $84C0;
  GL_TEXTURE1                             = $84C1;
  GL_TEXTURE2                             = $84C2;
  GL_TEXTURE3                             = $84C3;
  GL_TEXTURE4                             = $84C4;
  GL_TEXTURE5                             = $84C5;
  GL_TEXTURE6                             = $84C6;
  GL_TEXTURE7                             = $84C7;
  GL_TEXTURE8                             = $84C8;
  GL_TEXTURE9                             = $84C9;
  GL_TEXTURE10                            = $84CA;
  GL_TEXTURE11                            = $84CB;
  GL_TEXTURE12                            = $84CC;
  GL_TEXTURE13                            = $84CD;
  GL_TEXTURE14                            = $84CE;
  GL_TEXTURE15                            = $84CF;
  GL_TEXTURE16                            = $84D0;
  GL_TEXTURE17                            = $84D1;
  GL_TEXTURE18                            = $84D2;
  GL_TEXTURE19                            = $84D3;
  GL_TEXTURE20                            = $84D4;
  GL_TEXTURE21                            = $84D5;
  GL_TEXTURE22                            = $84D6;
  GL_TEXTURE23                            = $84D7;
  GL_TEXTURE24                            = $84D8;
  GL_TEXTURE25                            = $84D9;
  GL_TEXTURE26                            = $84DA;
  GL_TEXTURE27                            = $84DB;
  GL_TEXTURE28                            = $84DC;
  GL_TEXTURE29                            = $84DD;
  GL_TEXTURE30                            = $84DE;
  GL_TEXTURE31                            = $84DF;
  GL_ACTIVE_TEXTURE                       = $84E0;
  // TextureWrapMode
  GL_REPEAT                               = $2901;
  GL_CLAMP_TO_EDGE                        = $812F;
  GL_MIRRORED_REPEAT                      = $8370;
  // Uniform Types
  GL_FLOAT_VEC2                           = $8B50;
  GL_FLOAT_VEC3                           = $8B51;
  GL_FLOAT_VEC4                           = $8B52;
  GL_INT_VEC2                             = $8B53;
  GL_INT_VEC3                             = $8B54;
  GL_INT_VEC4                             = $8B55;
  GL_BOOL                                 = $8B56;
  GL_BOOL_VEC2                            = $8B57;
  GL_BOOL_VEC3                            = $8B58;
  GL_BOOL_VEC4                            = $8B59;
  GL_FLOAT_MAT2                           = $8B5A;
  GL_FLOAT_MAT3                           = $8B5B;
  GL_FLOAT_MAT4                           = $8B5C;
  GL_SAMPLER_2D                           = $8B5E;
  GL_SAMPLER_CUBE                         = $8B60;
  // Vertex Arrays
  GL_VERTEX_ATTRIB_ARRAY_ENABLED          = $8622;
  GL_VERTEX_ATTRIB_ARRAY_SIZE             = $8623;
  GL_VERTEX_ATTRIB_ARRAY_STRIDE           = $8624;
  GL_VERTEX_ATTRIB_ARRAY_TYPE             = $8625;
  GL_VERTEX_ATTRIB_ARRAY_NORMALIZED       = $886A;
  GL_VERTEX_ATTRIB_ARRAY_POINTER          = $8645;
  GL_VERTEX_ATTRIB_ARRAY_BUFFER_BINDING   = $889F;
  // Read Format
  GL_IMPLEMENTATION_COLOR_READ_TYPE       = $8B9A;
  GL_IMPLEMENTATION_COLOR_READ_FORMAT     = $8B9B;
  { Shader Source  }
  GL_COMPILE_STATUS                       = $8B81;
  GL_INFO_LOG_LENGTH                      = $8B84;
  GL_SHADER_SOURCE_LENGTH                 = $8B88;
  GL_SHADER_COMPILER                      = $8DFA;
  { Shader Binary  }
  GL_SHADER_BINARY_FORMATS                = $8DF8;
  GL_NUM_SHADER_BINARY_FORMATS            = $8DF9;
  { Shader Precision-Specified Types  }
  GL_LOW_FLOAT                            = $8DF0;
  GL_MEDIUM_FLOAT                         = $8DF1;
  GL_HIGH_FLOAT                           = $8DF2;
  GL_LOW_INT                              = $8DF3;
  GL_MEDIUM_INT                           = $8DF4;
  GL_HIGH_INT                             = $8DF5;
  { Framebuffer Object.  }
  GL_FRAMEBUFFER                          = $8D40;
  GL_RENDERBUFFER                         = $8D41;
  GL_RGBA4                                = $8056;
  GL_RGB5_A1                              = $8057;
  GL_RGB565                               = $8D62;
  GL_DEPTH_COMPONENT16                    = $81A5;
  GL_STENCIL_INDEX                        = $1901;
  GL_STENCIL_INDEX8                       = $8D48;
  GL_RENDERBUFFER_WIDTH                   = $8D42;
  GL_RENDERBUFFER_HEIGHT                  = $8D43;
  GL_RENDERBUFFER_INTERNAL_FORMAT         = $8D44;
  GL_RENDERBUFFER_RED_SIZE                = $8D50;
  GL_RENDERBUFFER_GREEN_SIZE              = $8D51;
  GL_RENDERBUFFER_BLUE_SIZE               = $8D52;
  GL_RENDERBUFFER_ALPHA_SIZE              = $8D53;
  GL_RENDERBUFFER_DEPTH_SIZE              = $8D54;
  GL_RENDERBUFFER_STENCIL_SIZE            = $8D55;
  GL_FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE   = $8CD0;
  GL_FRAMEBUFFER_ATTACHMENT_OBJECT_NAME   = $8CD1;
  GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL = $8CD2;
  GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE = $8CD3;
  GL_COLOR_ATTACHMENT0                            = $8CE0;
  GL_DEPTH_ATTACHMENT                             = $8D00;
  GL_STENCIL_ATTACHMENT                           = $8D20;
  GL_NONE                                         = 0;
  GL_FRAMEBUFFER_COMPLETE                         = $8CD5;
  GL_FRAMEBUFFER_INCOMPLETE_ATTACHMENT            = $8CD6;
  GL_FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT    = $8CD7;
  GL_FRAMEBUFFER_INCOMPLETE_DIMENSIONS            = $8CD9;
  GL_FRAMEBUFFER_UNSUPPORTED                      = $8CDD;
  GL_FRAMEBUFFER_BINDING                          = $8CA6;
  GL_RENDERBUFFER_BINDING                         = $8CA7;
  GL_MAX_RENDERBUFFER_SIZE                        = $84E8;
  GL_INVALID_FRAMEBUFFER_OPERATION                = $0506;


{-------------------------------------------------------------------------
* GL core functions.
*----------------------------------------------------------------------- }


procedure glActiveTexture(texture: GLenum);  cdecl; external libname;
procedure glAttachShader(_program: GLuint; shader: GLuint);  cdecl; external libname;

procedure glBindAttribLocation(_program: GLuint; index: GLuint; name: Pchar);  cdecl; external libname;
procedure glBindBuffer(target: GLenum; buffer: GLuint);  cdecl; external libname;
procedure glBindFramebuffer(target: GLenum; framebuffer: GLuint);  cdecl; external libname;
procedure glBindRenderbuffer(target: GLenum; renderbuffer: GLuint);  cdecl; external libname;
procedure glBindTexture(target: GLenum; texture: GLuint);  cdecl; external libname;
procedure glBlendColor(red: GLclampf; green: GLclampf; blue: GLclampf; alpha: GLclampf);  cdecl; external libname;
procedure glBlendEquation(mode: GLenum);  cdecl; external libname;
procedure glBlendEquationSeparate(modeRGB: GLenum; modeAlpha: GLenum);  cdecl; external libname;
procedure glBlendFunc(sfactor: GLenum; dfactor: GLenum);  cdecl; external libname;
procedure glBlendFuncSeparate(srcRGB: GLenum; dstRGB: GLenum; srcAlpha: GLenum; dstAlpha: GLenum);  cdecl; external libname;

procedure glBufferData(target: GLenum; size: GLsizeiptr; data: pointer; usage: GLenum);  cdecl; external libname;
procedure glBufferSubData(target: GLenum; offset: GLintptr; size: GLsizeiptr; data: pointer);  cdecl; external libname;

function  glCheckFramebufferStatus(target: GLenum): GLenum;  cdecl; external libname;

procedure glClear(mask: GLbitfield);  cdecl; external libname;
procedure glClearColor(red: GLclampf; green: GLclampf; blue: GLclampf; alpha: GLclampf);  cdecl; external libname;
procedure glClearDepthf(depth: GLclampf);  cdecl; external libname;
procedure glClearStencil(s: GLint);  cdecl; external libname;
procedure glColorMask(red: GLboolean; green: GLboolean; blue: GLboolean; alpha: GLboolean);  cdecl; external libname;

procedure glCompileShader(shader: GLuint);  cdecl; external libname;

procedure glCompressedTexImage2D(target: GLenum; level: GLint; internalformat: GLenum; width: GLsizei; height: GLsizei; border: GLint; imageSize: GLsizei; data: pointer);  cdecl; external libname;
procedure glCompressedTexSubImage2D(target: GLenum; level: GLint; xoffset: GLint; yoffset: GLint; width: GLsizei; height: GLsizei; format: GLenum; imageSize: GLsizei; data: pointer);  cdecl; external libname;
procedure glCopyTexImage2D(target: GLenum; level: GLint; internalformat: GLenum; x: GLint; y: GLint; width: GLsizei; height: GLsizei; border: GLint);  cdecl; external libname;
procedure glCopyTexSubImage2D(target: GLenum; level: GLint; xoffset: GLint; yoffset: GLint; x: GLint; y: GLint; width: GLsizei; height: GLsizei);  cdecl; external libname;

function  glCreateProgram: GLuint;  cdecl; external libname;
function  glCreateShader(_type: GLenum): GLuint;  cdecl; external libname;

procedure glCullFace(mode: GLenum);  cdecl; external libname;

procedure glDeleteBuffers(n: GLsizei; buffers: PGLuint);  cdecl; external libname;
procedure glDeleteFramebuffers(n: GLsizei; framebuffers: PGLuint);  cdecl; external libname;
procedure glDeleteProgram(_program: GLuint);  cdecl; external libname;
procedure glDeleteRenderbuffers(n: GLsizei; renderbuffers: PGLuint);  cdecl; external libname;
procedure glDeleteShader(shader: GLuint);  cdecl; external libname;

procedure glDeleteTextures(n: GLsizei; textures: PGLuint);  cdecl; external libname;

procedure glDepthFunc(func: GLenum);  cdecl; external libname;
procedure glDepthMask(flag: GLboolean);  cdecl; external libname;
procedure glDepthRangef(zNear: GLclampf; zFar: GLclampf);  cdecl; external libname;

procedure glDetachShader(_program: GLuint; shader: GLuint);  cdecl; external libname;
procedure glDisable(cap: GLenum);  cdecl; external libname;
procedure glDisableVertexAttribArray(index: GLuint);  cdecl; external libname;

procedure glDrawArrays(mode: GLenum; first: GLint; count: GLsizei);  cdecl; external libname;
procedure glDrawElements(mode: GLenum; count: GLsizei; _type: GLenum; indices: pointer);  cdecl; external libname;

procedure glEnable(cap: GLenum);  cdecl; external libname;
procedure glEnableVertexAttribArray(index: GLuint);  cdecl; external libname;

procedure glFinish;  cdecl; external libname;
procedure glFlush;  cdecl; external libname;

procedure glFramebufferRenderbuffer(target: GLenum; attachment: GLenum; renderbuffertarget: GLenum; renderbuffer: GLuint);  cdecl; external libname;
procedure glFramebufferTexture2D(target: GLenum; attachment: GLenum; textarget: GLenum; texture: GLuint; level: GLint);  cdecl; external libname;

procedure glFrontFace(mode: GLenum);  cdecl; external libname;

procedure glGenBuffers(n: GLsizei; buffers: PGLuint);  cdecl; external libname;
procedure glGenerateMipmap(target: GLenum);  cdecl; external libname;
procedure glGenFramebuffers(n: GLsizei; framebuffers: PGLuint);  cdecl; external libname;
procedure glGenRenderbuffers(n: GLsizei; renderbuffers: PGLuint);  cdecl; external libname;
procedure glGenTextures(n: GLsizei; textures: PGLuint);  cdecl; external libname;

procedure glGetActiveAttrib(_program: GLuint; index: GLuint; bufsize: GLsizei;  length: PGLsizei; size: PGLint; _type: PGLenum; name: Pchar);  cdecl; external libname;
procedure glGetActiveUniform(_program: GLuint; index: GLuint; bufsize: GLsizei;  length: PGLsizei; size: PGLint; _type: PGLenum; name: Pchar);  cdecl; external libname;
procedure glGetAttachedShaders(_program: GLuint; maxcount: GLsizei; count: PGLsizei; shaders: PGLuint);  cdecl; external libname;
function  glGetAttribLocation(_program: GLuint; name: Pchar): LongInt;  cdecl; external libname;
procedure glGetBooleanv(pname: GLenum; params: PGLboolean);  cdecl; external libname;
procedure glGetBufferParameteriv(target: GLenum; pname: GLenum; params: PGLint);  cdecl; external libname;
function  glGetError: GLenum;  cdecl; external libname;
procedure glGetFloatv(pname: GLenum; params: PGLfloat);  cdecl; external libname;
procedure glGetFramebufferAttachmentParameteriv(target: GLenum; attachment: GLenum; pname: GLenum; params: PGLint);  cdecl; external libname;
procedure glGetIntegerv(pname: GLenum; params: PGLint);  cdecl; external libname;
procedure glGetProgramiv(_program: GLuint; pname: GLenum; params: PGLint);  cdecl; external libname;
procedure glGetProgramInfoLog(_program: GLuint; bufsize: GLsizei; length: PGLsizei; infolog: Pchar);  cdecl; external libname;
procedure glGetRenderbufferParameteriv(target: GLenum; pname: GLenum; params: PGLint);  cdecl; external libname;
procedure glGetShaderiv(shader: GLuint; pname: GLenum; params: PGLint);  cdecl; external libname;
procedure glGetShaderInfoLog(shader: GLuint; bufsize: GLsizei; length: PGLsizei; infolog: Pchar);  cdecl; external libname;
procedure glGetShaderPrecisionFormat(shadertype: GLenum; precisiontype: GLenum; range: PGLint; precision: PGLint);  cdecl; external libname;
procedure glGetShaderSource(shader: GLuint; bufsize: GLsizei; length: PGLsizei; source: Pchar);  cdecl; external libname;

function  glGetString(name: GLenum): PGLubyte;  cdecl; external libname;
procedure glGetTexParameterfv(target: GLenum; pname: GLenum; params: PGLfloat);  cdecl; external libname;
procedure glGetTexParameteriv(target: GLenum; pname: GLenum; params: PGLint);  cdecl; external libname;
procedure glGetUniformfv(_program: GLuint; location: GLint; params: PGLfloat);  cdecl; external libname;
procedure glGetUniformiv(_program: GLuint; location: GLint; params: PGLint);  cdecl; external libname;

function  glGetUniformLocation(_program: GLuint; name: Pchar): LongInt;  cdecl; external libname;
procedure glGetVertexAttribfv(index: GLuint; pname: GLenum; params: PGLfloat);  cdecl; external libname;
procedure glGetVertexAttribiv(index: GLuint; pname: GLenum; params: PGLint);  cdecl; external libname;
procedure glGetVertexAttribPointerv(index: GLuint; pname: GLenum; pointer: Ppointer);  cdecl; external libname;

procedure glHint(target: GLenum; mode: GLenum);  cdecl; external libname;

function  glIsBuffer(buffer: GLuint): GLboolean;  cdecl; external libname;
function  glIsEnabled(cap: GLenum): GLboolean;  cdecl; external libname;
function  glIsFramebuffer(framebuffer: GLuint): GLboolean;  cdecl; external libname;
function  glIsProgram(_program: GLuint): GLboolean;  cdecl; external libname;
function  glIsRenderbuffer(renderbuffer: GLuint): GLboolean;  cdecl; external libname;
function  glIsShader(shader: GLuint): GLboolean;  cdecl; external libname;
function  glIsTexture(texture: GLuint): GLboolean;  cdecl; external libname;

procedure glLineWidth(width: GLfloat);  cdecl; external libname;

procedure glLinkProgram(_program: GLuint);  cdecl; external libname;
procedure glPixelStorei(pname: GLenum; param: GLint);  cdecl; external libname;
procedure glPolygonOffset(factor: GLfloat; units: GLfloat);  cdecl; external libname;
procedure glReadPixels(x: GLint; y: GLint; width: GLsizei; height: GLsizei; format: GLenum; _type: GLenum; pixels: pointer);  cdecl; external libname;

procedure glReleaseShaderCompiler;  cdecl; external libname;
procedure glRenderbufferStorage(target: GLenum; internalformat: GLenum; width: GLsizei; height: GLsizei);  cdecl; external libname;
procedure glSampleCoverage(value: GLclampf; invert: GLboolean);  cdecl; external libname;
procedure glScissor(x: GLint; y: GLint; width: GLsizei; height: GLsizei);  cdecl; external libname;

procedure glShaderBinary(n: GLsizei; shaders: PGLuint; binaryformat: GLenum; binary: pointer; length: GLsizei);  cdecl; external libname;
procedure glShaderSource(shader: GLuint; count: GLsizei; _string: PPchar; length: PGLint);  cdecl; external libname;

procedure glStencilFunc(func: GLenum; ref: GLint; mask: GLuint);  cdecl; external libname;
procedure glStencilFuncSeparate(face: GLenum; func: GLenum; ref: GLint; mask: GLuint);  cdecl; external libname;
procedure glStencilMask(mask: GLuint);  cdecl; external libname;
procedure glStencilMaskSeparate(face: GLenum; mask: GLuint);  cdecl; external libname;
procedure glStencilOp(fail: GLenum; zfail: GLenum; zpass: GLenum);  cdecl; external libname;
procedure glStencilOpSeparate(face: GLenum; fail: GLenum; zfail: GLenum; zpass: GLenum);  cdecl; external libname;

procedure glTexImage2D(target: GLenum; level: GLint; internalformat: GLint; width: GLsizei; height: GLsizei; border: GLint; format: GLenum; _type: GLenum;pixels: pointer);  cdecl; external libname;
procedure glTexParameterf(target: GLenum; pname: GLenum; param: GLfloat);  cdecl; external libname;
procedure glTexParameterfv(target: GLenum; pname: GLenum; params: PGLfloat);  cdecl; external libname;
procedure glTexParameteri(target: GLenum; pname: GLenum; param: GLint);  cdecl; external libname;
procedure glTexParameteriv(target: GLenum; pname: GLenum; params: PGLint);  cdecl; external libname;
procedure glTexSubImage2D(target: GLenum; level: GLint; xoffset: GLint; yoffset: GLint; width: GLsizei; height: GLsizei; format: GLenum; _type: GLenum; pixels: pointer);  cdecl; external libname;

procedure glUniform1f(location: GLint; x: GLfloat);  cdecl; external libname;
procedure glUniform1fv(location: GLint; count: GLsizei; v: PGLfloat);  cdecl; external libname;
procedure glUniform1i(location: GLint; x: GLint);  cdecl; external libname;
procedure glUniform1iv(location: GLint; count: GLsizei; v: PGLint);  cdecl; external libname;
procedure glUniform2f(location: GLint; x: GLfloat; y: GLfloat);  cdecl; external libname;
procedure glUniform2fv(location: GLint; count: GLsizei; v: PGLfloat);  cdecl; external libname;
procedure glUniform2i(location: GLint; x: GLint; y: GLint);  cdecl; external libname;
procedure glUniform2iv(location: GLint; count: GLsizei; v: PGLint);  cdecl; external libname;
procedure glUniform3f(location: GLint; x: GLfloat; y: GLfloat; z: GLfloat);  cdecl; external libname;
procedure glUniform3fv(location: GLint; count: GLsizei; v: PGLfloat);  cdecl; external libname;
procedure glUniform3i(location: GLint; x: GLint; y: GLint; z: GLint);  cdecl; external libname;
procedure glUniform3iv(location: GLint; count: GLsizei; v: PGLint);  cdecl; external libname;
procedure glUniform4f(location: GLint; x: GLfloat; y: GLfloat; z: GLfloat; w: GLfloat);  cdecl; external libname;
procedure glUniform4fv(location: GLint; count: GLsizei; v: PGLfloat);  cdecl; external libname;
procedure glUniform4i(location: GLint; x: GLint; y: GLint; z: GLint; w: GLint);  cdecl; external libname;
procedure glUniform4iv(location: GLint; count: GLsizei; v: PGLint);  cdecl; external libname;
procedure glUniformMatrix2fv(location: GLint; count: GLsizei; transpose: GLboolean; value: PGLfloat);  cdecl; external libname;
procedure glUniformMatrix3fv(location: GLint; count: GLsizei; transpose: GLboolean; value: PGLfloat);  cdecl; external libname;
procedure glUniformMatrix4fv(location: GLint; count: GLsizei; transpose: GLboolean; value: PGLfloat);  cdecl; external libname;

procedure glUseProgram(_program: GLuint);  cdecl; external libname;
procedure glValidateProgram(_program: GLuint);  cdecl; external libname;

procedure glVertexAttrib1f(indx: GLuint; x: GLfloat);  cdecl; external libname;
procedure glVertexAttrib1fv(indx: GLuint; values: PGLfloat);  cdecl; external libname;
procedure glVertexAttrib2f(indx: GLuint; x: GLfloat; y: GLfloat);  cdecl; external libname;
procedure glVertexAttrib2fv(indx: GLuint; values: PGLfloat);  cdecl; external libname;
procedure glVertexAttrib3f(indx: GLuint; x: GLfloat; y: GLfloat; z: GLfloat);  cdecl; external libname;
procedure glVertexAttrib3fv(indx: GLuint; values: PGLfloat);  cdecl; external libname;
procedure glVertexAttrib4f(indx: GLuint; x: GLfloat; y: GLfloat; z: GLfloat; w: GLfloat);  cdecl; external libname;
procedure glVertexAttrib4fv(indx: GLuint; values: PGLfloat);  cdecl; external libname;
procedure glVertexAttribPointer(indx: GLuint; size: GLint; _type: GLenum; normalized: GLboolean; stride: GLsizei; ptr: pointer);  cdecl; external libname;

procedure glViewport(x: GLint; y: GLint; width: GLsizei; height: GLsizei);  cdecl; external libname;

implementation

end.
