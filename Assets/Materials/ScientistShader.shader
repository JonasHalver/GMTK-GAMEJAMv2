// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ScientistShader"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		_Details("Details", 2D) = "white" {}
		_Float5("Float 3", Float) = 0.1
		_blueparts("blue parts", 2D) = "white" {}
		[HDR]_LightColor("LightColor", Color) = (0,8,6.839216,0)
		_Float2("Float 0", Float) = 0.5
		_Color0("Color 0", Color) = (1,0,0,0)
		_HurtFloat("HurtFloat", Float) = 1
		_10(",8", Float) = 0.8
		_LightAmount2("LightAmount", Float) = 0
		_Darkness1("Darkness", Color) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
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
		uniform float _HurtFloat;
		uniform sampler2D _Details;
		uniform float4 _Details_ST;
		uniform float4 _Color0;
		uniform float4 _Darkness1;
		uniform sampler2D _blueparts;
		uniform float4 _blueparts_ST;
		uniform float4 _LightColor;
		uniform float _10;
		uniform float _Float2;
		uniform float _Float5;
		uniform float _LightAmount2;

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
			float4 tex2DNode10 = tex2D( _MainTex, uv_MainTex );
			float temp_output_23_0 = ( 1.0 - ase_lightAtten );
			float temp_output_3_0_g37 = ( _10 - temp_output_23_0 );
			float temp_output_3_0_g38 = ( _Float2 - temp_output_23_0 );
			float temp_output_3_0_g39 = ( _Float5 - temp_output_23_0 );
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float2 uv_Details = i.uv_texcoord * _Details_ST.xy + _Details_ST.zw;
			float4 tex2DNode5 = tex2D( _Details, uv_Details );
			float4 temp_output_17_0 = ( tex2DNode5.a * _Color0 );
			float4 ifLocalVar18 = 0;
			if( _HurtFloat <= 0.0 )
				ifLocalVar18 = temp_output_17_0;
			else
				ifLocalVar18 = ( tex2DNode5 * tex2DNode5.a );
			float4 temp_output_13_0 = ( tex2DNode10 + ifLocalVar18 );
			c.rgb = ( ( saturate( ( ( saturate( ( temp_output_3_0_g37 / fwidth( temp_output_3_0_g37 ) ) ) + saturate( ( temp_output_3_0_g38 / fwidth( temp_output_3_0_g38 ) ) ) + saturate( ( temp_output_3_0_g39 / fwidth( temp_output_3_0_g39 ) ) ) ) / 3.0 ) ) * ( ase_lightColor * ase_lightAtten ) * _LightAmount2 ) * temp_output_13_0 ).rgb;
			c.a = tex2DNode10.a;
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
			float4 tex2DNode10 = tex2D( _MainTex, uv_MainTex );
			float2 uv_Details = i.uv_texcoord * _Details_ST.xy + _Details_ST.zw;
			float4 tex2DNode5 = tex2D( _Details, uv_Details );
			float4 temp_output_17_0 = ( tex2DNode5.a * _Color0 );
			float4 ifLocalVar18 = 0;
			if( _HurtFloat <= 0.0 )
				ifLocalVar18 = temp_output_17_0;
			else
				ifLocalVar18 = ( tex2DNode5 * tex2DNode5.a );
			float4 temp_output_13_0 = ( tex2DNode10 + ifLocalVar18 );
			o.Albedo = temp_output_13_0.rgb;
			float2 uv_blueparts = i.uv_texcoord * _blueparts_ST.xy + _blueparts_ST.zw;
			o.Emission = ( ( _Darkness1 * temp_output_13_0 ) + ( tex2D( _blueparts, uv_blueparts ).a * _LightColor ) ).rgb;
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
138;341;1920;870;1062.573;515.6012;1.558124;True;False
Node;AmplifyShaderEditor.CommentaryNode;21;-1264.428,1613.697;Inherit;False;812;304;Comment;3;34;33;22;Attenuation and Ambient;1,1,1,1;0;0
Node;AmplifyShaderEditor.LightAttenuation;22;-1085.962,1787.926;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-1921.167,1521.471;Inherit;False;Property;_10;,8;8;0;Create;True;0;0;False;0;False;0.8;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-1935.378,1258.784;Inherit;False;Property;_Float2;Float 0;5;0;Create;True;0;0;False;0;False;0.5;0.82;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-2052.803,958.7775;Inherit;False;Property;_Float5;Float 3;2;0;Create;True;0;0;False;0;False;0.1;0.67;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;23;-2038.001,1083.549;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;5;-1551.75,-50.58139;Inherit;True;Property;_Details;Details;1;0;Create;True;0;0;False;0;False;-1;5e318612ecd628f40ba5ae543e38d735;a3d834338de19e54793ac63401ff85be;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;29;-1885.743,845.8447;Inherit;True;Step Antialiasing;-1;;39;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;28;-1739.412,1088.431;Inherit;True;Step Antialiasing;-1;;38;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;27;-1695.622,1374.248;Inherit;True;Step Antialiasing;-1;;37;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;14;-1174.395,562.3613;Inherit;False;Property;_Color0;Color 0;6;0;Create;True;0;0;False;0;False;1,0,0,0;1,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;31;-1033.702,1226.431;Inherit;False;Constant;_Float4;Float 2;5;0;Create;True;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-800.4492,132.2513;Inherit;False;Property;_HurtFloat;HurtFloat;7;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-815.4492,259.2513;Inherit;False;Constant;_Float1;Float 1;6;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-918.1952,430.0817;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;30;-1232.883,1104.662;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-1084.839,57.53776;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ConditionalIfNode;18;-578.3348,220.3578;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LightColorNode;33;-1133.111,1645.139;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleDivideOpNode;32;-865.814,1188.429;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;10;-1102.987,-152.0314;Inherit;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;False;0;False;-1;8aab57678e699264bb2debaf53355714;3e64c8d690460114a9a894a2276cf353;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;6;-1549.901,465.9947;Inherit;False;Property;_LightColor;LightColor;4;1;[HDR];Create;True;0;0;False;0;False;0,8,6.839216,0;0,8,6.839216,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;3;-1611.655,189.7863;Inherit;True;Property;_blueparts;blue parts;3;0;Create;True;0;0;False;0;False;-1;b2376661e8252874eb2b8d1e6cc96a6b;aa12e2aae9d626f4ba740c472ede6d21;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;13;-313.275,-196.6389;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-608.4271,1661.697;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-341.7333,1704.975;Inherit;False;Property;_LightAmount2;LightAmount;9;0;Create;True;0;0;False;0;False;0;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;36;-559.3603,1205.687;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;44;24.55239,-462.9891;Inherit;False;Property;_Darkness1;Darkness;10;0;Create;True;0;0;False;0;False;0,0,0,0;0.2705882,0.1294118,0.3568628,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;270.9945,-254.341;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;37;-2615.53,1077.22;Inherit;False;540.401;320.6003;Comment;3;41;40;39;N . L;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-1222.708,281.4667;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-229.6541,1141.447;Inherit;True;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;39;-2551.53,1285.22;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;40;-2503.529,1125.22;Inherit;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;41;-2215.529,1189.22;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;212.6921,286.8556;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;45;452.9797,-181.0493;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;693.4212,-57.03191;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;ScientistShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;23;0;22;0
WireConnection;29;1;23;0
WireConnection;29;2;24;0
WireConnection;28;1;23;0
WireConnection;28;2;25;0
WireConnection;27;1;23;0
WireConnection;27;2;26;0
WireConnection;17;0;5;4
WireConnection;17;1;14;0
WireConnection;30;0;27;0
WireConnection;30;1;28;0
WireConnection;30;2;29;0
WireConnection;8;0;5;0
WireConnection;8;1;5;4
WireConnection;18;0;19;0
WireConnection;18;1;20;0
WireConnection;18;2;8;0
WireConnection;18;3;17;0
WireConnection;18;4;17;0
WireConnection;32;0;30;0
WireConnection;32;1;31;0
WireConnection;13;0;10;0
WireConnection;13;1;18;0
WireConnection;34;0;33;0
WireConnection;34;1;22;0
WireConnection;36;0;32;0
WireConnection;43;0;44;0
WireConnection;43;1;13;0
WireConnection;9;0;3;4
WireConnection;9;1;6;0
WireConnection;38;0;36;0
WireConnection;38;1;34;0
WireConnection;38;2;35;0
WireConnection;41;0;40;0
WireConnection;41;1;39;0
WireConnection;42;0;38;0
WireConnection;42;1;13;0
WireConnection;45;0;43;0
WireConnection;45;1;9;0
WireConnection;0;0;13;0
WireConnection;0;2;45;0
WireConnection;0;9;10;4
WireConnection;0;13;42;0
ASEEND*/
//CHKSM=47EDAC285A016C34F5DD2971176A87A91F969197