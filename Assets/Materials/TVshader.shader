// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "TVshader"
{
	Properties
	{
		_Float1("Float 1", Float) = 0.1
		_MainColor("MainColor", Color) = (0,0,0,0)
		_MainTex("MainTex", 2D) = "white" {}
		_Float2("Float 2", Float) = 0.5
		_Speed1(",", Float) = 0.1
		_8(",8", Float) = 0.8
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_LightAmount("LightAmount", Float) = 0
		_Direction("Direction", Vector) = (0,1,0,0)
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_Tiling("Tiling", Vector) = (1,1,0,0)
		_TVc("TV c", 2D) = "white" {}
		[HDR]_Color1("Color 1", Color) = (10.68063,0.1511407,8.837468,0)
		_Blinkspeed("Blinkspeed", Float) = 1
		_Pixelsize("Pixelsize", Range( 0.001 , 5)) = 0.07
		_NoiseAmount("NoiseAmount", Range( 0 , 10)) = 1.09
		[HDR]_Color2("Color 2", Color) = (0,0,0,0)
		_pinkteal("pink-teal", Range( 0 , 2)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float4 _MainColor;
		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;
		uniform float4 _Color2;
		uniform float4 _Color1;
		uniform float _pinkteal;
		uniform float _Blinkspeed;
		uniform sampler2D _TextureSample1;
		uniform float _Speed1;
		uniform float2 _Direction;
		uniform float2 _Tiling;
		uniform sampler2D _TVc;
		uniform float4 _TVc_ST;
		uniform float _Pixelsize;
		uniform float _NoiseAmount;
		uniform float _8;
		uniform float _Float2;
		uniform float _Float1;
		uniform float _LightAmount;


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			#ifdef UNITY_PASS_FORWARDBASE
			float ase_lightAtten = data.atten;
			if( _LightColor0.a == 0)
			ase_lightAtten = 0;
			#else
			float3 ase_lightAttenRGB = gi.light.color / ( ( _LightColor0.rgb ) + 0.000001 );
			float ase_lightAtten = max( max( ase_lightAttenRGB.r, ase_lightAttenRGB.g ), ase_lightAttenRGB.b );
			#endif
			#if defined(HANDLE_SHADOWS_BLENDING_IN_GI)
			half bakedAtten = UnitySampleBakedOcclusion(data.lightmapUV.xy, data.worldPos);
			float zDist = dot(_WorldSpaceCameraPos - data.worldPos, UNITY_MATRIX_V[2].xyz);
			float fadeDist = UnityComputeShadowFadeDistance(data.worldPos, zDist);
			ase_lightAtten = UnityMixRealtimeAndBakedShadows(data.atten, bakedAtten, UnityComputeShadowFade(fadeDist));
			#endif
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode1 = tex2D( _MainTex, uv_MainTex );
			float temp_output_52_0 = ( 1.0 - ase_lightAtten );
			float temp_output_3_0_g41 = ( _8 - temp_output_52_0 );
			float temp_output_3_0_g42 = ( _Float2 - temp_output_52_0 );
			float temp_output_3_0_g40 = ( _Float1 - temp_output_52_0 );
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float4 tex2DNode2 = tex2D( _TextureSample0, uv_TextureSample0 );
			c.rgb = ( tex2DNode1.a * ( ( saturate( ( ( saturate( ( temp_output_3_0_g41 / fwidth( temp_output_3_0_g41 ) ) ) + saturate( ( temp_output_3_0_g42 / fwidth( temp_output_3_0_g42 ) ) ) + saturate( ( temp_output_3_0_g40 / fwidth( temp_output_3_0_g40 ) ) ) ) / 3.0 ) ) * ( ase_lightColor * ase_lightAtten ) * _LightAmount ) * ( tex2DNode1.a * _MainColor ) ) * ( 1.0 - tex2DNode2.a ) ).rgb;
			c.a = tex2DNode1.a;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode1 = tex2D( _MainTex, uv_MainTex );
			o.Albedo = ( tex2DNode1 * _MainColor ).rgb;
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float4 tex2DNode2 = tex2D( _TextureSample0, uv_TextureSample0 );
			float4 lerpResult47 = lerp( _Color2 , _Color1 , step( _pinkteal , 1.0 ));
			float mulTime34 = _Time.y * _Blinkspeed;
			float mulTime10 = _Time.y * _Speed1;
			float2 uv_TexCoord11 = i.uv_texcoord * _Tiling;
			float2 panner12 = ( mulTime10 * _Direction + uv_TexCoord11);
			float4 tex2DNode13 = tex2D( _TextureSample1, panner12 );
			float2 uv_TVc = i.uv_texcoord * _TVc_ST.xy + _TVc_ST.zw;
			float temp_output_19_0 = ( 1.0 - tex2D( _TVc, uv_TVc ).a );
			float3 ase_worldPos = i.worldPos;
			float simplePerlin2D40 = snoise( ceil( ( ase_worldPos / _Pixelsize ) ).xy*_Time.y );
			simplePerlin2D40 = simplePerlin2D40*0.5 + 0.5;
			o.Emission = ( _MainColor + ( tex2DNode2.a * ( ( lerpResult47 * ( abs( sin( mulTime34 ) ) + 0.5 ) ) * tex2DNode13 * tex2DNode13 ) * temp_output_19_0 * temp_output_19_0 * ( ( ( simplePerlin2D40 + 0.0 ) * _NoiseAmount ) * tex2DNode1.a ) ) ).rgb;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
				surf( surfIN, o );
				UnityGI gi;
				UNITY_INITIALIZE_OUTPUT( UnityGI, gi );
				o.Alpha = LightingStandardCustomLighting( o, worldViewDir, gi ).a;
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18200
0;421;1920;598;1117.206;374.305;1.3;True;True
Node;AmplifyShaderEditor.CommentaryNode;50;-1450.632,2545.201;Inherit;False;812;304;Comment;3;63;61;51;Attenuation and Ambient;1,1,1,1;0;0
Node;AmplifyShaderEditor.LightAttenuation;51;-1276.916,2721.806;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-1688.14,122.1205;Inherit;False;Property;_Blinkspeed;Blinkspeed;14;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-1816.531,1110.143;Inherit;False;Property;_Pixelsize;Pixelsize;15;0;Create;True;0;0;False;0;False;0.07;0.001;0.001;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;55;-2107.371,2452.975;Inherit;False;Property;_8;,8;6;0;Create;True;0;0;False;0;False;0.8;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;52;-2224.205,2015.054;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;53;-2239.006,1890.282;Inherit;False;Property;_Float1;Float 1;1;0;Create;True;0;0;False;0;False;0.1;0.67;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;36;-1718.555,911.0132;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleTimeNode;34;-1558.14,134.1205;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;54;-2121.583,2190.289;Inherit;False;Property;_Float2;Float 2;4;0;Create;True;0;0;False;0;False;0.5;0.82;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-1622.8,578.6983;Inherit;False;Property;_Speed1;,;5;0;Create;True;0;0;False;0;False;0.1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;26;-1354.271,170.8668;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;8;-1747.161,314.752;Inherit;False;Property;_Tiling;Tiling;11;0;Create;True;0;0;False;0;False;1,1;1,6;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;49;-1653.195,-43.60432;Inherit;False;Property;_pinkteal;pink-teal;18;0;Create;True;0;0;False;0;False;0;1.08;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;57;-1925.616,2019.936;Inherit;True;Step Antialiasing;-1;;42;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;58;-1881.827,2305.752;Inherit;True;Step Antialiasing;-1;;41;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;38;-1484.239,973.5248;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;56;-2071.947,1777.349;Inherit;True;Step Antialiasing;-1;;40;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;48;-1215.808,-253.4592;Inherit;False;Property;_Color2;Color 2;17;1;[HDR];Create;True;0;0;False;0;False;0,0,0,0;0,16,11.67059,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;41;-1300.037,1202.189;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;45;-978.307,-144.8598;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;60;-1219.905,2157.936;Inherit;False;Constant;_Float3;Float 3;5;0;Create;True;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;59;-1419.086,2036.167;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;15;-1220.911,-87.5929;Inherit;False;Property;_Color1;Color 1;13;1;[HDR];Create;True;0;0;False;0;False;10.68063,0.1511407,8.837468,0;10.68063,0.1511407,8.837468,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CeilOpNode;39;-1277.037,965.1888;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector2Node;9;-1476.538,439.103;Inherit;False;Property;_Direction;Direction;9;0;Create;True;0;0;False;0;False;0,1;0,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;30;-1256.14,267.1205;Inherit;False;Constant;_Float0;Float 0;8;0;Create;True;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;23;-1224.806,186.1579;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;11;-1540.538,306.103;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;10;-1475.538,579.103;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;32;-1086.14,248.1205;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;61;-1319.315,2576.643;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;44;-985.4976,1289.562;Inherit;False;Property;_NoiseAmount;NoiseAmount;16;0;Create;True;0;0;False;0;False;1.09;1.38;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;12;-1277.538,412.103;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;40;-1074.037,952.1888;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;62;-1052.017,2119.934;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;47;-893.9534,-196.4141;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;13;-1103.245,351.6953;Inherit;True;Property;_TextureSample1;Texture Sample 1;10;0;Create;True;0;0;False;0;False;-1;c707a33d5ba2eb845be2eaf08bf739e4;c707a33d5ba2eb845be2eaf08bf739e4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-923.4141,221.1579;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;42;-768.0363,927.1888;Inherit;True;ConstantBiasScale;-1;;43;63208df05c83e8e49a48ffbdce2e43a0;0;3;3;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-576.4604,-338.6139;Inherit;True;Property;_MainTex;MainTex;3;0;Create;True;0;0;False;0;False;-1;3c07c21665cf01e4b8e945f28b91f2d3;095e261b0789b2f4d8e1fa9f00d198dd;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;5;-587.4971,-128.2569;Inherit;False;Property;_MainColor;MainColor;2;0;Create;True;0;0;False;0;False;0,0,0,0;0.2264151,0.2264151,0.2264151,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;66;-745.5638,2137.192;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;65;-527.9369,2636.479;Inherit;False;Property;_LightAmount;LightAmount;8;0;Create;True;0;0;False;0;False;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;17;-947.4675,611.5745;Inherit;True;Property;_TVc;TV c;12;0;Create;True;0;0;False;0;False;-1;c77dcee86c9df6449a5d7c295ff2b8c8;c77dcee86c9df6449a5d7c295ff2b8c8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;-794.6298,2593.201;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;-268.2508,535.0524;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-743.9311,260.0148;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;71;-378.4872,1269.146;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;70;-415.8568,2072.951;Inherit;True;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;2;-693.11,73.65754;Inherit;True;Property;_TextureSample0;Texture Sample 0;7;0;Create;True;0;0;False;0;False;-1;3c07c21665cf01e4b8e945f28b91f2d3;3c07c21665cf01e4b8e945f28b91f2d3;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;19;-512.8425,490.4102;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;72;561.8502,1432.671;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;78;152.3298,435.1128;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;69;-2801.735,2008.725;Inherit;False;540.401;320.6003;Comment;3;76;75;73;N . L;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-147.4912,158.3395;Inherit;False;5;5;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldNormalVector;75;-2689.733,2056.725;Inherit;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-53.89133,-221.2607;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DotProductOpNode;76;-2401.732,2120.725;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;405.9985,694.1773;Inherit;True;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;6;38.45883,0.2192154;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;73;-2737.734,2216.724;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;427.9179,-219.4145;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;TVshader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;52;0;51;0
WireConnection;34;0;35;0
WireConnection;26;0;34;0
WireConnection;57;1;52;0
WireConnection;57;2;54;0
WireConnection;58;1;52;0
WireConnection;58;2;55;0
WireConnection;38;0;36;0
WireConnection;38;1;37;0
WireConnection;56;1;52;0
WireConnection;56;2;53;0
WireConnection;45;0;49;0
WireConnection;59;0;58;0
WireConnection;59;1;57;0
WireConnection;59;2;56;0
WireConnection;39;0;38;0
WireConnection;23;0;26;0
WireConnection;11;0;8;0
WireConnection;10;0;7;0
WireConnection;32;0;23;0
WireConnection;32;1;30;0
WireConnection;12;0;11;0
WireConnection;12;2;9;0
WireConnection;12;1;10;0
WireConnection;40;0;39;0
WireConnection;40;1;41;0
WireConnection;62;0;59;0
WireConnection;62;1;60;0
WireConnection;47;0;48;0
WireConnection;47;1;15;0
WireConnection;47;2;45;0
WireConnection;13;1;12;0
WireConnection;21;0;47;0
WireConnection;21;1;32;0
WireConnection;42;3;40;0
WireConnection;42;2;44;0
WireConnection;66;0;62;0
WireConnection;63;0;61;0
WireConnection;63;1;51;0
WireConnection;43;0;42;0
WireConnection;43;1;1;4
WireConnection;14;0;21;0
WireConnection;14;1;13;0
WireConnection;14;2;13;0
WireConnection;71;0;1;4
WireConnection;71;1;5;0
WireConnection;70;0;66;0
WireConnection;70;1;63;0
WireConnection;70;2;65;0
WireConnection;19;0;17;4
WireConnection;72;0;70;0
WireConnection;72;1;71;0
WireConnection;78;0;2;4
WireConnection;4;0;2;4
WireConnection;4;1;14;0
WireConnection;4;2;19;0
WireConnection;4;3;19;0
WireConnection;4;4;43;0
WireConnection;3;0;1;0
WireConnection;3;1;5;0
WireConnection;76;0;75;0
WireConnection;76;1;73;0
WireConnection;77;0;1;4
WireConnection;77;1;72;0
WireConnection;77;2;78;0
WireConnection;6;0;5;0
WireConnection;6;1;4;0
WireConnection;0;0;3;0
WireConnection;0;2;6;0
WireConnection;0;9;1;4
WireConnection;0;13;77;0
ASEEND*/
//CHKSM=689CB600A1E9471EA44B9A7910FBA51FBC072903