{* 
 * Open source license agreement: Lazarus Modified LGPL 
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *}


unit Laz_And_GLESv1_Canvas_h;


{$ifdef fpc}
 {$mode delphi}
{$endif}

interface

const
   //libname = 'libGLESv1_CM.so';

   (* by Leledumbo for Linux users:
       1. Build all libraries in the  ../LazAndroidWizard/linux/dummylibs
       2. Put it somewhere ldconfig can find (or just run ldconfig with their directories as arguments)

       "The idea of this is just to make the package installable in the IDE,
       applications will still use the android version of the libraries."

       ref. http://forum.lazarus.freepascal.org/index.php/topic,21919.msg137216/topicseen.html
   *)


   (*Modified by Stephano [14-04-2014]: "I saw Leledumbo's post and the readme file. The 2 solutions that I proposed are much cleaner and don't
     require any extra steps from the user."
    ref. http://forum.lazarus.freepascal.org/index.php/topic,21919.105.html *)


libname = {$ifdef linux}'libGL.so'{$else}'libGLESv1_CM.so'{$endif};

type
  khronos_int8_t                          = ShortInt;
  khronos_float_t                         = Single;
  khronos_int32_t                         = Integer;
  khronos_intptr_t                        = ^Integer;
  khronos_ssize_t                         = Integer;
  khronos_uint8_t                         = Byte;

  GLvoid                                  = pointer;
  GLenum                                  = LongWord;
  GLboolean                               = byte;
  GLbitfield                              = LongWord;
  GLbyte                                  = khronos_int8_t;
  GLshort                                 = smallint;
  GLint                                   = longint;
  GLsizei                                 = longint;
  GLubyte                                 = khronos_uint8_t;
  GLushort                                = word;
  GLuint                                  = LongWord;
  GLfloat                                 = khronos_float_t;
  GLclampf                                = khronos_float_t;
  GLfixed                                 = khronos_int32_t;
  GLclampx                                = khronos_int32_t;
  GLintptr                                = khronos_intptr_t;
  GLsizeiptr                              = khronos_ssize_t;

  PGLfloat                                = ^GLfloat;
  PGLvoid                                 = ^GLvoid;
  PGLubyte                                = ^GLubyte;
  PGLint                                  = ^GLint;
  PGLboolean                              = ^GLboolean;
  PGLuint                                 = ^GLuint;
  PGLfixed                                = ^GLfixed;

// OpenGL ES core versions
const
  GL_VERSION_ES_CM_1_0                    = 1;
  GL_VERSION_ES_CL_1_0                    = 1;
  GL_VERSION_ES_CM_1_1                    = 1;
  GL_VERSION_ES_CL_1_1                    = 1;
  // ClearBufferMask
  GL_DEPTH_BUFFER_BIT                     = $00000100;
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
  // AlphaFunction
  GL_NEVER                                = $0200;
  GL_LESS                                 = $0201;
  GL_EQUAL                                = $0202;
  GL_LEQUAL                               = $0203;
  GL_GREATER                              = $0204;
  GL_NOTEQUAL                             = $0205;
  GL_GEQUAL                               = $0206;
  GL_ALWAYS                               = $0207;
  // BlendingFactorDest
  GL_ZERO                                 = 0;
  GL_ONE                                  = 1;
  GL_SRC_COLOR                            = $0300;
  GL_ONE_MINUS_SRC_COLOR                  = $0301;
  GL_SRC_ALPHA = $0302;
  GL_ONE_MINUS_SRC_ALPHA                  = $0303;
  GL_DST_ALPHA = $0304;
  GL_ONE_MINUS_DST_ALPHA                  = $0305;
  // BlendingFactorSrc
  //      GL_ZERO
  //      GL_ONE
  GL_DST_COLOR                            = $0306;
  GL_ONE_MINUS_DST_COLOR                  = $0307;
  GL_SRC_ALPHA_SATURATE                   = $0308;
  //      GL_SRC_ALPHA
  //      GL_ONE_MINUS_SRC_ALPHA
  //      GL_DST_ALPHA
  //      GL_ONE_MINUS_DST_ALPHA
  // ClipPlaneName
  GL_CLIP_PLANE0                          = $3000;
  GL_CLIP_PLANE1                          = $3001;
  GL_CLIP_PLANE2                          = $3002;
  GL_CLIP_PLANE3                          = $3003;
  GL_CLIP_PLANE4                          = $3004;
  GL_CLIP_PLANE5                          = $3005;
  // ColorMaterialFace
  //      GL_FRONT_AND_BACK
  // ColorMaterialParameter
  //      GL_AMBIENT_AND_DIFFUSE
  // ColorPointerType
  //      GL_UNSIGNED_BYTE
  //      GL_FLOAT
  //      GL_FIXED
  // CullFaceMode
  GL_FRONT                                = $0404;
  GL_BACK                                 = $0405;
  GL_FRONT_AND_BACK = $0408;
  // DepthFunction
  //      GL_NEVER
  //      GL_LESS
  //      GL_EQUAL
  //      GL_LEQUAL
  //      GL_GREATER
  //      GL_NOTEQUAL
  //      GL_GEQUAL
  //      GL_ALWAYS
  // EnableCap
  GL_FOG                                  = $0B60;
  GL_LIGHTING                             = $0B50;
  GL_TEXTURE_2D                           = $0DE1;
  GL_CULL_FACE                            = $0B44;
  GL_ALPHA_TEST                           = $0BC0;
  GL_BLEND                                = $0BE2;
  GL_COLOR_LOGIC_OP                       = $0BF2;
  GL_DITHER                               = $0BD0;
  GL_STENCIL_TEST                         = $0B90;
  GL_DEPTH_TEST                           = $0B71;
  //      GL_LIGHT0
  //      GL_LIGHT1
  //      GL_LIGHT2
  //      GL_LIGHT3
  //      GL_LIGHT4
  //      GL_LIGHT5
  //      GL_LIGHT6
  //      GL_LIGHT7
  GL_POINT_SMOOTH                         = $0B10;
  GL_LINE_SMOOTH                          = $0B20;
  GL_COLOR_MATERIAL                       = $0B57;
  GL_NORMALIZE                            = $0BA1;
  GL_RESCALE_NORMAL                       = $803A;
  GL_VERTEX_ARRAY                         = $8074;
  GL_NORMAL_ARRAY                         = $8075;
  GL_COLOR_ARRAY                          = $8076;
  GL_TEXTURE_COORD_ARRAY                  = $8078;
  GL_MULTISAMPLE                          = $809D;
  GL_SAMPLE_ALPHA_TO_COVERAGE             = $809E;
  GL_SAMPLE_ALPHA_TO_ONE                  = $809F;
  GL_SAMPLE_COVERAGE = $80A0;
  // ErrorCode
  GL_NO_ERROR                             = 0;
  GL_INVALID_ENUM                         = $0500;
  GL_INVALID_VALUE                        = $0501;
  GL_INVALID_OPERATION                    = $0502;
  GL_STACK_OVERFLOW                       = $0503;
  GL_STACK_UNDERFLOW                      = $0504;
  GL_OUT_OF_MEMORY                        = $0505;
  // FogMode
  //      GL_LINEAR
  GL_EXP                                  = $0800;
  GL_EXP2                                 = $0801;
  // FogParameter
  GL_FOG_DENSITY                          = $0B62;
  GL_FOG_START                            = $0B63;
  GL_FOG_END                              = $0B64;
  GL_FOG_MODE                             = $0B65;
  GL_FOG_COLOR                            = $0B66;
  // FrontFaceDirection
  GL_CW                                   = $0900;
  GL_CCW                                  = $0901;
  // GetPName
  GL_CURRENT_COLOR                        = $0B00;
  GL_CURRENT_NORMAL                       = $0B02;
  GL_CURRENT_TEXTURE_COORDS               = $0B03;
  GL_POINT_SIZE                           = $0B11;
  GL_POINT_SIZE_MIN                       = $8126;
  GL_POINT_SIZE_MAX                       = $8127;
  GL_POINT_FADE_THRESHOLD_SIZE            = $8128;
  GL_POINT_DISTANCE_ATTENUATION           = $8129;
  GL_SMOOTH_POINT_SIZE_RANGE              = $0B12;
  GL_LINE_WIDTH                           = $0B21;
  GL_SMOOTH_LINE_WIDTH_RANGE              = $0B22;
  GL_ALIASED_POINT_SIZE_RANGE             = $846D;
  GL_ALIASED_LINE_WIDTH_RANGE             = $846E;
  GL_CULL_FACE_MODE                       = $0B45;
  GL_FRONT_FACE                           = $0B46;
  GL_SHADE_MODEL                          = $0B54;
  GL_DEPTH_RANGE                          = $0B70;
  GL_DEPTH_WRITEMASK                      = $0B72;
  GL_DEPTH_CLEAR_VALUE                    = $0B73;
  GL_DEPTH_FUNC                           = $0B74;
  GL_STENCIL_CLEAR_VALUE                  = $0B91;
  GL_STENCIL_FUNC                         = $0B92;
  GL_STENCIL_VALUE_MASK                   = $0B93;
  GL_STENCIL_FAIL                         = $0B94;
  GL_STENCIL_PASS_DEPTH_FAIL              = $0B95;
  GL_STENCIL_PASS_DEPTH_PASS              = $0B96;
  GL_STENCIL_REF                          = $0B97;
  GL_STENCIL_WRITEMASK                    = $0B98;
  GL_MATRIX_MODE                          = $0BA0;
  GL_VIEWPORT                             = $0BA2;
  GL_MODELVIEW_STACK_DEPTH                = $0BA3;
  GL_PROJECTION_STACK_DEPTH               = $0BA4;
  GL_TEXTURE_STACK_DEPTH                  = $0BA5;
  GL_MODELVIEW_MATRIX                     = $0BA6;
  GL_PROJECTION_MATRIX                    = $0BA7;
  GL_TEXTURE_MATRIX                       = $0BA8;
  GL_ALPHA_TEST_FUNC                      = $0BC1;
  GL_ALPHA_TEST_REF                       = $0BC2;
  GL_BLEND_DST                            = $0BE0;
  GL_BLEND_SRC                            = $0BE1;
  GL_LOGIC_OP_MODE                        = $0BF0;
  GL_SCISSOR_BOX                          = $0C10;
  GL_SCISSOR_TEST                         = $0C11;
  GL_COLOR_CLEAR_VALUE                    = $0C22;
  GL_COLOR_WRITEMASK                      = $0C23;
  GL_MAX_LIGHTS                           = $0D31;
  GL_MAX_CLIP_PLANES                      = $0D32;
  GL_MAX_TEXTURE_SIZE                     = $0D33;
  GL_MAX_MODELVIEW_STACK_DEPTH            = $0D36;
  GL_MAX_PROJECTION_STACK_DEPTH           = $0D38;
  GL_MAX_TEXTURE_STACK_DEPTH              = $0D39;
  GL_MAX_VIEWPORT_DIMS                    = $0D3A;
  GL_MAX_TEXTURE_UNITS                    = $84E2;
  GL_SUBPIXEL_BITS                        = $0D50;
  GL_RED_BITS                             = $0D52;
  GL_GREEN_BITS                           = $0D53;
  GL_BLUE_BITS                            = $0D54;
  GL_ALPHA_BITS                           = $0D55;
  GL_DEPTH_BITS                           = $0D56;
  GL_STENCIL_BITS                         = $0D57;
  GL_POLYGON_OFFSET_UNITS                 = $2A00;
  GL_POLYGON_OFFSET_FILL                  = $8037;
  GL_POLYGON_OFFSET_FACTOR                = $8038;
  GL_TEXTURE_BINDING_2D                   = $8069;
  GL_VERTEX_ARRAY_SIZE                    = $807A;
  GL_VERTEX_ARRAY_TYPE                    = $807B;
  GL_VERTEX_ARRAY_STRIDE                  = $807C;
  GL_NORMAL_ARRAY_TYPE                    = $807E;
  GL_NORMAL_ARRAY_STRIDE                  = $807F;
  GL_COLOR_ARRAY_SIZE                     = $8081;
  GL_COLOR_ARRAY_TYPE                     = $8082;
  GL_COLOR_ARRAY_STRIDE                   = $8083;
  GL_TEXTURE_COORD_ARRAY_SIZE             = $8088;
  GL_TEXTURE_COORD_ARRAY_TYPE             = $8089;
  GL_TEXTURE_COORD_ARRAY_STRIDE           = $808A;
  GL_VERTEX_ARRAY_POINTER                 = $808E;
  GL_NORMAL_ARRAY_POINTER                 = $808F;
  GL_COLOR_ARRAY_POINTER                  = $8090;
  GL_TEXTURE_COORD_ARRAY_POINTER          = $8092;
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
  GL_PERSPECTIVE_CORRECTION_HINT          = $0C50;
  GL_POINT_SMOOTH_HINT                    = $0C51;
  GL_LINE_SMOOTH_HINT                     = $0C52;
  GL_FOG_HINT                             = $0C54;
  GL_GENERATE_MIPMAP_HINT                 = $8192;
  // LightModelParameter
  GL_LIGHT_MODEL_AMBIENT                  = $0B53;
  GL_LIGHT_MODEL_TWO_SIDE                 = $0B52;
  // LightParameter
  GL_AMBIENT                              = $1200;
  GL_DIFFUSE                              = $1201;
  GL_SPECULAR                             = $1202;
  GL_POSITION                             = $1203;
  GL_SPOT_DIRECTION                       = $1204;
  GL_SPOT_EXPONENT                        = $1205;
  GL_SPOT_CUTOFF                          = $1206;
  GL_CONSTANT_ATTENUATION                 = $1207;
  GL_LINEAR_ATTENUATION                   = $1208;
  GL_QUADRATIC_ATTENUATION                = $1209;
  // DataType
  GL_BYTE                                 = $1400;
  GL_UNSIGNED_BYTE                        = $1401;
  GL_SHORT                                = $1402;
  GL_UNSIGNED_SHORT                       = $1403;
  GL_FLOAT                                = $1406;
  GL_FIXED                                = $140C;
  // LogicOp
  GL_CLEAR                                = $1500;
  GL_AND                                  = $1501;
  GL_AND_REVERSE                          = $1502;
  GL_COPY                                 = $1503;
  GL_AND_INVERTED                         = $1504;
  GL_NOOP                                 = $1505;
  GL_XOR                                  = $1506;
  GL_OR                                   = $1507;
  GL_NOR                                  = $1508;
  GL_EQUIV                                = $1509;
  GL_INVERT                               = $150A;
  GL_OR_REVERSE                           = $150B;
  GL_COPY_INVERTED                        = $150C;
  GL_OR_INVERTED                          = $150D;
  GL_NAND                                 = $150E;
  GL_SET                                  = $150F;
  // MaterialFace
  //      GL_FRONT_AND_BACK
  // MaterialParameter
  GL_EMISSION                             = $1600;
  GL_SHININESS                            = $1601;
  GL_AMBIENT_AND_DIFFUSE                  = $1602;
  //      GL_AMBIENT
  //      GL_DIFFUSE
  //      GL_SPECULAR
  // MatrixMode
  GL_MODELVIEW                            = $1700;
  GL_PROJECTION                           = $1701;
  GL_TEXTURE                              = $1702;
  // NormalPointerType
  //      GL_BYTE
  //      GL_SHORT
  //      GL_FLOAT
  //      GL_FIXED
  // PixelFormat
  GL_ALPHA                                = $1906;
  GL_RGB                                  = $1907;
  GL_RGBA                                 = $1908;
  GL_LUMINANCE                            = $1909;
  GL_LUMINANCE_ALPHA                      = $190A;
  // PixelStoreParameter
  GL_UNPACK_ALIGNMENT                     = $0CF5;
  GL_PACK_ALIGNMENT                       = $0D05;
  // PixelType
  //      GL_UNSIGNED_BYTE
  GL_UNSIGNED_SHORT_4_4_4_4               = $8033;
  GL_UNSIGNED_SHORT_5_5_5_1               = $8034;
  GL_UNSIGNED_SHORT_5_6_5                 = $8363;
  // ShadingModel
  GL_FLAT                                 = $1D00;
  GL_SMOOTH                               = $1D01;
  // StencilFunction
  //      GL_NEVER
  //      GL_LESS
  //      GL_EQUAL
  //      GL_LEQUAL
  //      GL_GREATER
  //      GL_NOTEQUAL
  //      GL_GEQUAL
  //      GL_ALWAYS
  // StencilOp
  //      GL_ZERO
  GL_KEEP                                 = $1E00;
  GL_REPLACE                              = $1E01;
  GL_INCR                                 = $1E02;
  GL_DECR                                 = $1E03;
  //      GL_INVERT
  // StringName
  GL_VENDOR                               = $1F00;
  GL_RENDERER                             = $1F01;
  GL_VERSION                              = $1F02;
  GL_EXTENSIONS                           = $1F03;
  // TexCoordPointerType
  //      GL_SHORT
  //      GL_FLOAT
  //      GL_FIXED
  //      GL_BYTE
  // TextureEnvMode
  GL_MODULATE                             = $2100;
  GL_DECAL                                = $2101;
  //      GL_BLEND
  GL_ADD                                  = $0104;
  //      GL_REPLACE
  // TextureEnvParameter
  GL_TEXTURE_ENV_MODE                     = $2200;
  GL_TEXTURE_ENV_COLOR                    = $2201;
  // TextureEnvTarget
  GL_TEXTURE_ENV                          = $2300;
  // TextureMagFilter
  GL_NEAREST                              = $2600;
  GL_LINEAR                               = $2601;
  // TextureMinFilter
  //      GL_NEAREST
  //      GL_LINEAR
  GL_NEAREST_MIPMAP_NEAREST               = $2700;
  GL_LINEAR_MIPMAP_NEAREST                = $2701;
  GL_NEAREST_MIPMAP_LINEAR                = $2702;
  GL_LINEAR_MIPMAP_LINEAR                 = $2703;
  // TextureParameterName
  GL_TEXTURE_MAG_FILTER                   = $2800;
  GL_TEXTURE_MIN_FILTER                   = $2801;
  GL_TEXTURE_WRAP_S                       = $2802;
  GL_TEXTURE_WRAP_T                       = $2803;
  GL_GENERATE_MIPMAP                      = $8191;
  // TextureTarget
  //      GL_TEXTURE_2D
  // TextureUnit
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
  GL_CLIENT_ACTIVE_TEXTURE                = $84E1;
  // TextureWrapMode
  GL_REPEAT                               = $2901;
  GL_CLAMP_TO_EDGE                        = $812F;
  // VertexPointerType
  //      GL_SHORT
  //      GL_FLOAT
  //      GL_FIXED
  //      GL_BYTE
  // LightName
  GL_LIGHT0                               = $4000;
  GL_LIGHT1                               = $4001;
  GL_LIGHT2                               = $4002;
  GL_LIGHT3                               = $4003;
  GL_LIGHT4                               = $4004;
  GL_LIGHT5                               = $4005;
  GL_LIGHT6                               = $4006;
  GL_LIGHT7                               = $4007;
  // Buffer Objects
  GL_ARRAY_BUFFER                         = $8892;
  GL_ELEMENT_ARRAY_BUFFER                 = $8893;
  GL_ARRAY_BUFFER_BINDING                 = $8894;
  GL_ELEMENT_ARRAY_BUFFER_BINDING         = $8895;
  GL_VERTEX_ARRAY_BUFFER_BINDING          = $8896;
  GL_NORMAL_ARRAY_BUFFER_BINDING          = $8897;
  GL_COLOR_ARRAY_BUFFER_BINDING           = $8898;
  GL_TEXTURE_COORD_ARRAY_BUFFER_BINDING   = $889A;
  GL_STATIC_DRAW                          = $88E4;
  GL_DYNAMIC_DRAW                         = $88E8;
  GL_BUFFER_SIZE                          = $8764;
  GL_BUFFER_USAGE                         = $8765;
  // Texture combine + dot3
  GL_SUBTRACT                             = $84E7;
  GL_COMBINE                              = $8570;
  GL_COMBINE_RGB                          = $8571;
  GL_COMBINE_ALPHA                        = $8572;
  GL_RGB_SCALE                            = $8573;
  GL_ADD_SIGNED                           = $8574;
  GL_INTERPOLATE                          = $8575;
  GL_CONSTANT                             = $8576;
  GL_PRIMARY_COLOR                        = $8577;
  GL_PREVIOUS                             = $8578;
  GL_OPERAND0_RGB                         = $8590;
  GL_OPERAND1_RGB                         = $8591;
  GL_OPERAND2_RGB                         = $8592;
  GL_OPERAND0_ALPHA                       = $8598;
  GL_OPERAND1_ALPHA                       = $8599;
  GL_OPERAND2_ALPHA                       = $859A;
  GL_ALPHA_SCALE                          = $0D1C;
  GL_SRC0_RGB                             = $8580;
  GL_SRC1_RGB                             = $8581;
  GL_SRC2_RGB                             = $8582;
  GL_SRC0_ALPHA                           = $8588;
  GL_SRC1_ALPHA                           = $8589;
  GL_SRC2_ALPHA                           = $858A;
  GL_DOT3_RGB                             = $86AE;
  GL_DOT3_RGBA                            = $86AF;

// required OES extension tokens

// OES_read_format
//const
  GL_IMPLEMENTATION_COLOR_READ_TYPE_OES   = $8B9A;
  GL_IMPLEMENTATION_COLOR_READ_FORMAT_OES = $8B9B;

  // GL_OES_compressed_paletted_texture
  GL_PALETTE4_RGB8_OES                    = $8B90;
  GL_PALETTE4_RGBA8_OES                   = $8B91;
  GL_PALETTE4_R5_G6_B5_OES                = $8B92;
  GL_PALETTE4_RGBA4_OES                   = $8B93;
  GL_PALETTE4_RGB5_A1_OES                 = $8B94;
  GL_PALETTE8_RGB8_OES                    = $8B95;
  GL_PALETTE8_RGBA8_OES                   = $8B96;
  GL_PALETTE8_R5_G6_B5_OES                = $8B97;
  GL_PALETTE8_RGBA4_OES                   = $8B98;
  GL_PALETTE8_RGB5_A1_OES                 = $8B99;

  // OES_point_size_array
  GL_POINT_SIZE_ARRAY_OES                 = $8B9C;
  GL_POINT_SIZE_ARRAY_TYPE_OES            = $898A;
  GL_POINT_SIZE_ARRAY_STRIDE_OES          = $898B;
  GL_POINT_SIZE_ARRAY_POINTER_OES         = $898C;
  GL_POINT_SIZE_ARRAY_BUFFER_BINDING_OES  = $8B9F;

  // GL_OES_point_sprite
  GL_POINT_SPRITE_OES                     = $8861;
  GL_COORD_REPLACE_OES                    = $8862;

//-------------------------------------------------------------------------
// GL core functions.
//-------------------------------------------------------------------------

procedure glAlphaFunc(func: GLenum; ref: GLclampf); cdecl; external;
procedure glClearColor(red, green, blue, alpha: GLclampf); cdecl; external libname;
procedure glClearDepthf(depth: GLclampf); cdecl; external libname;
procedure glClipPlanef(plane: GLenum; equation: PGLfloat); cdecl; external libname;
procedure glColor4f(red, green, blue, alpha: GLfloat); cdecl; external libname;
procedure glDepthRangef(zNear, zFar: GLclampf); cdecl; external libname;
procedure glFogf(pname: GLenum; param: GLfloat); cdecl; external libname;
procedure glFogfv(pname: GLenum; params: PGLfloat); cdecl; external libname;
procedure glFrustumf(left, right, bottom, top, zNear, zFar: GLfloat); {$IFDEF android}cdecl; external libname;{$ENDIF}
procedure glGetClipPlanef(pname: GLenum; eqn: GLfloat); cdecl; external libname;
procedure glGetFloatv(pname: GLenum; params: PGLfloat); cdecl; external libname;
procedure glGetLightfv(light, pname: GLenum; params: PGLfloat); cdecl; external libname;
procedure glGetMaterialfv(face, pname: GLenum; params: PGLfloat); cdecl; external libname;
procedure glGetTexEnvfv(env, pname: GLenum; params: PGLfloat); cdecl; external libname;
procedure glGetTexParameterfv(target, pname: GLenum; params: PGLfloat); cdecl; external libname;
procedure glLightModelf(pname: GLenum; param: GLfloat); cdecl; external libname;
procedure glLightModelfv(pname: GLenum; params: PGLfloat); cdecl; external libname;
procedure glLightf(light, pname: GLenum; param: GLfloat); cdecl; external libname;
procedure glLightfv(light, pname: GLenum; params: PGLfloat); cdecl; external libname;
procedure glLineWidth(width: GLfloat); cdecl; external libname;
procedure glLoadMatrixf(m: PGLfloat); cdecl; external libname;
procedure glMaterialf(face, pname: GLenum; param: GLfloat); cdecl; external libname;
procedure glMaterialfv(face, pname: GLenum; params: PGLfloat); cdecl; external libname;
procedure glMultMatrixf(m: PGLfloat); cdecl; external libname;
procedure glMultiTexCoord4f(target: GLenum; s, t, r, q: GLfloat); cdecl; external libname;
procedure glNormal3f(nx, ny, nz: GLfloat); cdecl; external libname;
procedure glOrthof(left, right, bottom, top, zNear, zFar: GLfloat); cdecl; external libname;
procedure glPointParameterf(pname: GLenum; param: GLfloat); cdecl; external libname;
procedure glPointParameterfv(pname: GLenum; params: PGLfloat); cdecl; external libname;
procedure glPointSize(size: GLfloat); cdecl; external libname;
procedure glPolygonOffset(factor, units: GLfloat); cdecl; external libname;
procedure glRotatef(angle, x, y, z: GLfloat); cdecl; external libname;
procedure glScalef(x, y, z: GLfloat); cdecl; external libname;
procedure glTexEnvf(target, pname: GLenum; param: GLfloat); cdecl; external libname;
procedure glTexEnvfv(target, pname: GLenum; params: PGLfloat); cdecl; external libname;
procedure glTexParameterf(target, pname: GLenum; param: GLfloat); cdecl; external libname;
procedure glTexParameterfv(target, pname: GLenum; params: PGLfloat); cdecl; external libname;
procedure glTranslatef(x, y, z: GLfloat); cdecl; external libname;

// Available in both Common and Common-Lite profiles
procedure glActiveTexture(texture: GLenum); cdecl; external libname;
procedure glAlphaFuncx(func: GLenum; ref: GLclampx); cdecl; external libname;
procedure glBindBuffer(target: GLenum; buffer: GLuint); cdecl; external libname;
procedure glBindTexture(target: GLenum; texture: GLuint); cdecl; external libname;
procedure glBlendFunc(sfactor, dfactor: GLenum); cdecl; external libname;
procedure glBufferData(target: GLenum; size: GLsizeiptr; data: PGLvoid; usage: GLenum); cdecl; external libname;
procedure glBufferSubData(target: GLenum; offset: GLintptr; size: GLsizeiptr; data: PGLvoid); cdecl; external libname;
procedure glClear(mask: GLbitfield); cdecl; external libname;
procedure glClearColorx(red, green, blue, alpha: GLclampx); cdecl; external libname;
procedure glClearDepthx(depth: GLclampx); cdecl; external libname;
procedure glClearStencil(s: GLint); cdecl; external libname;
procedure glClientActiveTexture(texture: GLenum); cdecl; external libname;
procedure glClipPlanex(plane: GLenum; equation: PGLfixed); cdecl; external libname;
procedure glColor4ub(red, green, blue, alpha: GLubyte); cdecl; external libname;
procedure glColor4x(red, green, blue, alpha: GLfixed); cdecl; external libname;
procedure glColorMask(red, green, blue, alpha: GLboolean); cdecl; external libname;
procedure glColorPointer(size: GLint; type_: GLenum; stride: GLsizei; pointer: PGLvoid); cdecl; external libname;
procedure glCompressedTexImage2D(target: GLenum; level: GLint; internalformat: GLenum; width, height: GLsizei; border: GLint; imageSize: GLsizei; data: PGLvoid); cdecl; external libname;
procedure glCompressedTexSubImage2D(target: GLenum;level, xoffset, yoffset: GLint; width, height: GLsizei; format: GLenum;imageSize: GLsizei; data: PGLvoid); cdecl; external libname;
procedure glCopyTexImage2D(target: GLenum; level: GLint; internalformat: GLenum; x, y: GLint; width, height: GLsizei; border: GLint); cdecl; external libname;
procedure glCopyTexSubImage2D(target: GLenum; level, xoffset, yoffset, x, y: GLint; width, height: GLsizei); cdecl; external libname;
procedure glCullFace(mode: GLenum); cdecl; external libname;
procedure glDeleteBuffers(n: GLsizei; buffers: PGLuint); cdecl; external libname;
procedure glDeleteTextures(n: GLsizei; textures: PGLuint); cdecl; external libname;
procedure glDepthFunc(func: GLenum); cdecl; external libname;
procedure glDepthMask(flag: GLboolean); cdecl; external libname;
procedure glDepthRangex(zNear, zFar: GLclampx); cdecl; external libname;
procedure glDisable(cap: GLenum); cdecl; external libname;
procedure glDisableClientState(array_: GLenum); cdecl; external libname;
procedure glDrawArrays(mode: GLenum; first: GLint; count: GLsizei); cdecl; external libname;
procedure glDrawElements(mode: GLenum; count: GLsizei; type_: GLenum; indices: PGLvoid); cdecl; external libname;
procedure glEnable(cap: GLenum); cdecl; external libname;
procedure glEnableClientState(array_: GLenum); cdecl; external libname;
procedure glFinish; cdecl; external libname;
procedure glFlush; cdecl; external libname;
procedure glFogx(pname: GLenum; param: GLfixed); cdecl; external libname;
procedure glFogxv(pname: GLenum; params: PGLfixed); cdecl; external libname;
procedure glFrontFace(mode: GLenum); cdecl; external libname;
procedure glFrustumx(left, right, bottom, top, zNear, zFar: GLfixed); cdecl; external libname;
procedure glGetBooleanv(pname: GLenum; params: PGLboolean); cdecl; external libname;
procedure glGetBufferParameteriv(target, pname: GLenum; params: PGLint); cdecl; external libname;
procedure glGetClipPlanex(pname: GLenum; eqn: GLfixed); cdecl; external libname;
procedure glGenBuffers(n: GLsizei; buffers: PGLuint); cdecl; external libname;
procedure glGenTextures(n: GLsizei; var textures: GLuint); cdecl; external libname;
function glGetError: GLenum; cdecl; external libname;
procedure glGetFixedv(pname: GLenum; params: PGLfixed); cdecl; external libname;
procedure glGetIntegerv(pname: GLenum; params: PGLint); cdecl; external libname;
procedure glGetLightxv(light, pname: GLenum; params: PGLfixed); cdecl; external libname;
procedure glGetMaterialxv(face, pname: GLenum; params: PGLfixed); cdecl; external libname;
procedure glGetPointerv(pname: GLenum; params: PPointer); cdecl; external libname;
function glGetString(name_: GLenum): PGLubyte; cdecl; external libname;
procedure glGetTexEnviv(env, pname: GLenum; params: PGLint); cdecl; external libname;
procedure glGetTexEnvxv(env, pname: GLenum; params: PGLfixed); cdecl; external libname;
procedure glGetTexParameteriv(target, pname: GLenum; params: PGLint); cdecl; external libname;
procedure glGetTexParameterxv(target, pname: GLenum; params: PGLfixed); cdecl; external libname;
procedure glHint(target, mode: GLenum); cdecl; external libname;
function glIsBuffer(buffer: GLuint): GLboolean; cdecl; external libname;
function glIsEnabled(cap: GLenum): GLboolean; cdecl; external libname;
function glIsTexture(texture: GLuint): GLboolean; cdecl; external libname;
procedure glLightModelx(pname: GLenum; param: GLfixed); cdecl; external libname;
procedure glLightModelxv(pname: GLenum; params: PGLfixed); cdecl; external libname;
procedure glLightx(light, pname: GLenum; param: GLfixed); cdecl; external libname;
procedure glLightxv(light, pname: GLenum; params: PGLfixed); cdecl; external libname;
procedure glLineWidthx(width: GLfixed); cdecl; external libname;
procedure glLoadIdentity; cdecl; external libname;
procedure glLoadMatrixx(m: PGLfixed); cdecl; external libname;
procedure glLogicOp(opcode: GLenum); cdecl; external libname;
procedure glMaterialx(face, pname: GLenum; param: GLfixed); cdecl; external libname;
procedure glMaterialxv(face, pname: GLenum; params: PGLfixed); cdecl; external libname;
procedure glMatrixMode(mode: GLenum); cdecl; external libname;
procedure glMultMatrixx(m: PGLfixed); cdecl; external libname;
procedure glMultiTexCoord4x(target: GLenum; s, t, r, q: GLfixed); cdecl; external libname;
procedure glNormal3x(nx, ny, nz: GLfixed); cdecl; external libname;
procedure glNormalPointer(type_: GLenum; stride: GLsizei; pointer: PGLvoid); cdecl; external libname;
procedure glOrthox(left, right, bottom, top, zNear, zFar: GLfixed); cdecl; external libname;
procedure glPixelStorei(pname: GLenum; param: GLint); cdecl; external libname;
procedure glPointParameterx(pname: GLenum; param: GLfixed); cdecl; external libname;
procedure glPointParameterxv(pname: GLenum; params: PGLfixed); cdecl; external libname;
procedure glPointSizex(size: GLfixed); cdecl; external libname;
procedure glPolygonOffsetx(factor, units: GLfixed); cdecl; external libname;
procedure glPopMatrix; cdecl; external libname;
procedure glPushMatrix; cdecl; external libname;
procedure glReadPixels(x, y: GLint; width, height: GLsizei; format, type_: GLenum; pixels: PGLvoid); cdecl; external libname;
procedure glRotatex(angle, x, y, z: GLfixed); cdecl; external libname;
procedure glSampleCoverage(value: GLclampf; invert: GLboolean); cdecl; external libname;
procedure glSampleCoveragex(value: GLclampx; invert: GLboolean); cdecl; external libname;
procedure glScalex(x, y, z: GLfixed); cdecl; external libname;
procedure glScissor(x, y: GLint; width, height: GLsizei); cdecl; external libname;
procedure glShadeModel(mode: GLenum); cdecl; external libname;
procedure glStencilFunc(func: GLenum; ref: GLint; mask: GLuint); cdecl; external libname;
procedure glStencilMask(mask: GLuint); cdecl; external libname;
procedure glStencilOp(fail, zfail, zpass: GLenum); cdecl; external libname;
procedure glTexCoordPointer(size: GLint; type_: GLenum; stride: GLsizei; pointer: PGLvoid); cdecl; external libname;
procedure glTexEnvi(target, pname: GLenum; param: GLint); cdecl; external libname;
procedure glTexEnvx(target, pname: GLenum; param: GLfixed); cdecl; external libname;
procedure glTexEnviv(target, pname: GLenum; params: PGLint); cdecl; external libname;
procedure glTexEnvxv(target, pname: GLenum; params: PGLfixed); cdecl; external libname;
procedure glTexImage2D(target: GLenum; level, internalformat: GLint; width, height: GLsizei; border: GLint; format, type_: GLenum; pixels: PGLvoid); cdecl; external libname;
procedure glTexParameteri(target, pname: GLenum; param: GLint); cdecl; external libname;
procedure glTexParameterx(target, pname: GLenum; param: GLfixed); cdecl; external libname;
procedure glTexParameteriv(target, pname: GLenum; params: PGLint); cdecl; external libname;
procedure glTexParameterxv(target, pname: GLenum; params: PGLfixed); cdecl; external libname;
procedure glTexSubImage2D(target: GLenum; level, xoffset, yoffset: GLint; width, height: GLsizei; format, type_: GLenum; pixels: PGLvoid); cdecl; external libname;
procedure glTranslatex(x, y, z: GLfixed); cdecl; external libname;
procedure glVertexPointer(size: GLint; type_: GLenum; stride: GLsizei; pointer: PGLvoid); cdecl; external libname;
procedure glViewport(x, y: GLint; width, height: GLsizei); cdecl; external libname;


//------------------------------------------------------------------------
// Required OES extension functions
//------------------------------------------------------------------------

// GL_OES_read_format
const
  GL_OES_read_format = 1;
  GL_OES_compressed_paletted_texture = 1; // GL_OES_compressed_paletted_texture
  GL_OES_point_size_array = 1;            // GL_OES_point_size_array

//
procedure glPointSizePointerOES(type_: GLenum; stride: GLsizei; pointer: PGLvoid); cdecl; external libname;



implementation

{$IFnDEF android}
procedure glFrustumf(left, right, bottom, top, zNear, zFar: GLfloat);
begin

end;

{$ENDIF}

end.
