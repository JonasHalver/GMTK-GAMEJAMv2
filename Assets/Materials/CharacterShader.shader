// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "CharacterShader"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		_Float4("Float 3", Float) = 0.1
		_RimLight("RimLight", 2D) = "white" {}
		_Float1("Float 0", Float) = 0.5
		_Details("Details", 2D) = "white" {}
		_9(",8", Float) = 0.8
		_Lights("Lights", 2D) = "white" {}
		[Toggle(_RIMLIGHTFLASH_ON)] _RimLightFlash("RimLightFlash", Float) = 0
		_LightAmount1("LightAmount", Float) = 0
		[HDR]_LightColor("LightColor", Color) = (0.1153229,1,0,0)
		[HDR]_RimLightColor("RimLightColor", Color) = (1,0.7535237,0,0)
		_Darkness("Darkness", Color) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _RIMLIGHTFLASH_ON
		struct Input
		{
			float2 uv_texcoord;
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
		uniform sampler2D _Details;
		uniform float4 _Details_ST;
		uniform sampler2D _RimLight;
		uniform float4 _RimLight_ST;
		uniform float4 _RimLightColor;
		uniform float4 _Darkness;
		uniform sampler2D _Lights;
		uniform float4 _Lights_ST;
		uniform float4 _LightColor;
		uniform float _9;
		uniform float _Float1;
		uniform float _Float4;
		uniform float _LightAmount1;

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
			float temp_output_33_0 = ( 1.0 - ase_lightAtten );
			float temp_output_3_0_g37 = ( _9 - temp_output_33_0 );
			float temp_output_3_0_g38 = ( _Float1 - temp_output_33_0 );
			float temp_output_3_0_g39 = ( _Float4 - temp_output_33_0 );
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float2 uv_Details = i.uv_texcoord * _Details_ST.xy + _Details_ST.zw;
			float4 tex2DNode3 = tex2D( _Details, uv_Details );
			float4 color12 = IsGammaSpace() ? float4(0,0,0,0) : float4(0,0,0,0);
			float2 uv_RimLight = i.uv_texcoord * _RimLight_ST.xy + _RimLight_ST.zw;
			#ifdef _RIMLIGHTFLASH_ON
				float4 staticSwitch10 = ( tex2D( _RimLight, uv_RimLight ).a * _RimLightColor );
			#else
				float4 staticSwitch10 = color12;
			#endif
			float4 temp_output_7_0 = ( tex2DNode1 + ( tex2DNode3 * tex2DNode3.a ) + staticSwitch10 );
			c.rgb = ( ( saturate( ( ( saturate( ( temp_output_3_0_g37 / fwidth( temp_output_3_0_g37 ) ) ) + saturate( ( temp_output_3_0_g38 / fwidth( temp_output_3_0_g38 ) ) ) + saturate( ( temp_output_3_0_g39 / fwidth( temp_output_3_0_g39 ) ) ) ) / 3.0 ) ) * ( ase_lightColor * ase_lightAtten ) * _LightAmount1 ) * temp_output_7_0 ).rgb;
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
			float2 uv_Details = i.uv_texcoord * _Details_ST.xy + _Details_ST.zw;
			float4 tex2DNode3 = tex2D( _Details, uv_Details );
			float4 color12 = IsGammaSpace() ? float4(0,0,0,0) : float4(0,0,0,0);
			float2 uv_RimLight = i.uv_texcoord * _RimLight_ST.xy + _RimLight_ST.zw;
			#ifdef _RIMLIGHTFLASH_ON
				float4 staticSwitch10 = ( tex2D( _RimLight, uv_RimLight ).a * _RimLightColor );
			#else
				float4 staticSwitch10 = color12;
			#endif
			float4 temp_output_7_0 = ( tex2DNode1 + ( tex2DNode3 * tex2DNode3.a ) + staticSwitch10 );
			o.Albedo = temp_output_7_0.rgb;
			float2 uv_Lights = i.uv_texcoord * _Lights_ST.xy + _Lights_ST.zw;
			o.Emission = ( ( _Darkness * temp_output_7_0 ) + ( tex2D( _Lights, uv_Lights ).a * _LightColor ) ).rgb;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting alpha:fade keepalpha fullforwardshadows 

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
0;155;1920;864;1152.675;-920.2932;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;28;-1200.953,1537.798;Inherit;False;812;304;Comment;3;44;40;52;Attenuation and Ambient;1,1,1,1;0;0
Node;AmplifyShaderEditor.LightAttenuation;52;-1022.487,1712.027;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;33;-1974.526,1007.65;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-1989.328,882.8783;Inherit;False;Property;_Float4;Float 3;1;0;Create;True;0;0;False;0;False;0.1;0.67;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-1871.903,1182.885;Inherit;False;Property;_Float1;Float 0;3;0;Create;True;0;0;False;0;False;0.5;0.82;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-1857.692,1445.572;Inherit;False;Property;_9;,8;5;0;Create;True;0;0;False;0;False;0.8;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-974.0169,341.5175;Inherit;True;Property;_RimLight;RimLight;2;0;Create;True;0;0;False;0;False;-1;47c082d56d10bf046a9c8d492cb92cd8;47c082d56d10bf046a9c8d492cb92cd8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;35;-1822.268,769.9455;Inherit;True;Step Antialiasing;-1;;39;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;11;-886.8178,600.5392;Inherit;False;Property;_RimLightColor;RimLightColor;10;1;[HDR];Create;True;0;0;False;0;False;1,0.7535237,0,0;5.340313,2.382778,0.4282328,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;37;-1675.937,1012.532;Inherit;True;Step Antialiasing;-1;;38;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;36;-1632.147,1298.349;Inherit;True;Step Antialiasing;-1;;37;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;12;-555.395,240.2419;Inherit;False;Constant;_Color2;Color 2;5;0;Create;True;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;38;-1169.408,1028.763;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-603.0948,454.4327;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;3;-882.7777,-401.5166;Inherit;True;Property;_Details;Details;4;0;Create;True;0;0;False;0;False;-1;5e318612ecd628f40ba5ae543e38d735;5e318612ecd628f40ba5ae543e38d735;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;39;-970.2266,1150.532;Inherit;False;Constant;_Float3;Float 2;5;0;Create;True;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;40;-1069.636,1569.24;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.StaticSwitch;10;-320.3459,300.0228;Inherit;True;Property;_RimLightFlash;RimLightFlash;7;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-415.866,-293.3975;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1;-434.0141,-502.9666;Inherit;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;False;0;False;-1;8aab57678e699264bb2debaf53355714;8aab57678e699264bb2debaf53355714;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;41;-802.3385,1112.53;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;7;26.81494,-323.5921;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;56;188.787,-621.3108;Inherit;False;Property;_Darkness;Darkness;11;0;Create;True;0;0;False;0;False;0,0,0,0;0.2705882,0.1294118,0.3568628,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;-544.9516,1585.798;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;6;-880.928,115.0594;Inherit;False;Property;_LightColor;LightColor;9;1;[HDR];Create;True;0;0;False;0;False;0.1153229,1,0,0;0.6901961,5.992157,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;4;-942.6823,-161.1489;Inherit;True;Property;_Lights;Lights;6;0;Create;True;0;0;False;0;False;-1;b2376661e8252874eb2b8d1e6cc96a6b;b2376661e8252874eb2b8d1e6cc96a6b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;43;-278.2578,1629.076;Inherit;False;Property;_LightAmount1;LightAmount;8;0;Create;True;0;0;False;0;False;0;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;42;-495.8848,1129.788;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-455.8124,-46.73638;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;29;-2552.055,1001.321;Inherit;False;540.401;320.6003;Comment;3;51;50;49;N . L;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;-166.1786,1065.548;Inherit;True;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;400.5146,-287.6903;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldNormalVector;50;-2440.054,1049.321;Inherit;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;288.8426,161.7502;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DotProductOpNode;51;-2152.054,1113.321;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;49;-2488.055,1209.321;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;21;318.9852,68.19669;Inherit;False;Constant;;;7;0;Create;True;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;54;615.0045,-212.4437;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;27;1034.696,-262.6977;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;CharacterShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;33;0;52;0
WireConnection;35;1;33;0
WireConnection;35;2;34;0
WireConnection;37;1;33;0
WireConnection;37;2;32;0
WireConnection;36;1;33;0
WireConnection;36;2;31;0
WireConnection;38;0;36;0
WireConnection;38;1;37;0
WireConnection;38;2;35;0
WireConnection;9;0;2;4
WireConnection;9;1;11;0
WireConnection;10;1;12;0
WireConnection;10;0;9;0
WireConnection;8;0;3;0
WireConnection;8;1;3;4
WireConnection;41;0;38;0
WireConnection;41;1;39;0
WireConnection;7;0;1;0
WireConnection;7;1;8;0
WireConnection;7;2;10;0
WireConnection;44;0;40;0
WireConnection;44;1;52;0
WireConnection;42;0;41;0
WireConnection;5;0;4;4
WireConnection;5;1;6;0
WireConnection;45;0;42;0
WireConnection;45;1;44;0
WireConnection;45;2;43;0
WireConnection;55;0;56;0
WireConnection;55;1;7;0
WireConnection;53;0;45;0
WireConnection;53;1;7;0
WireConnection;51;0;50;0
WireConnection;51;1;49;0
WireConnection;54;0;55;0
WireConnection;54;1;5;0
WireConnection;27;0;7;0
WireConnection;27;2;54;0
WireConnection;27;9;1;4
WireConnection;27;13;53;0
ASEEND*/
//CHKSM=3FA0BC81100D6142BFEC1ACB2172E5F9666F6FD3