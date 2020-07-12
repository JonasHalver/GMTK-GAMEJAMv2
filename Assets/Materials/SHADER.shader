// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SHADER"
{
	Properties
	{
		_Float0("Float 0", Float) = 0.62
		_Float1("Float 1", Float) = 0.1
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
		#pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
		struct Input
		{
			float3 worldNormal;
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

		uniform float _Float1;
		uniform float _Float0;

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float3 ase_worldNormal = i.worldNormal;
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = Unity_SafeNormalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult14 = dot( ase_worldNormal , ase_worldlightDir );
			float3 _Vector1 = float3(0,0,0);
			float3 temp_output_43_0 = _Vector1;
			float3 temp_output_17_0 = ( 1.0 - ( saturate( dotResult14 ) + temp_output_43_0 ) );
			float temp_output_3_0_g14 = ( _Float1 - temp_output_17_0.x );
			float temp_output_3_0_g15 = ( _Float0 - temp_output_17_0.x );
			float4 color19 = IsGammaSpace() ? float4(0.1880476,0,0.3113208,0) : float4(0.02950213,0,0.07896997,0);
			float temp_output_3_0_g13 = ( 0.8 - temp_output_17_0.x );
			float4 temp_output_69_0 = ( ( float4( ( ase_lightColor.rgb * saturate( ( temp_output_3_0_g14 / fwidth( temp_output_3_0_g14 ) ) ) * ase_lightColor.a ) , 0.0 ) + float4( ( ase_lightColor.rgb * saturate( ( temp_output_3_0_g15 / fwidth( temp_output_3_0_g15 ) ) ) * ase_lightColor.a ) , 0.0 ) + color19 + float4( ( saturate( ( temp_output_3_0_g13 / fwidth( temp_output_3_0_g13 ) ) ) * ase_lightColor.rgb * ase_lightColor.a ) , 0.0 ) ) / 3.0 );
			c.rgb = temp_output_69_0.rgb;
			c.a = 1;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			float4 color19 = IsGammaSpace() ? float4(0.1880476,0,0.3113208,0) : float4(0.02950213,0,0.07896997,0);
			o.Albedo = color19.rgb;
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float3 ase_worldNormal = i.worldNormal;
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = Unity_SafeNormalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult14 = dot( ase_worldNormal , ase_worldlightDir );
			float3 _Vector1 = float3(0,0,0);
			float3 temp_output_43_0 = _Vector1;
			float3 temp_output_17_0 = ( 1.0 - ( saturate( dotResult14 ) + temp_output_43_0 ) );
			float temp_output_3_0_g14 = ( _Float1 - temp_output_17_0.x );
			float temp_output_3_0_g15 = ( _Float0 - temp_output_17_0.x );
			float temp_output_3_0_g13 = ( 0.8 - temp_output_17_0.x );
			float4 temp_output_69_0 = ( ( float4( ( ase_lightColor.rgb * saturate( ( temp_output_3_0_g14 / fwidth( temp_output_3_0_g14 ) ) ) * ase_lightColor.a ) , 0.0 ) + float4( ( ase_lightColor.rgb * saturate( ( temp_output_3_0_g15 / fwidth( temp_output_3_0_g15 ) ) ) * ase_lightColor.a ) , 0.0 ) + color19 + float4( ( saturate( ( temp_output_3_0_g13 / fwidth( temp_output_3_0_g13 ) ) ) * ase_lightColor.rgb * ase_lightColor.a ) , 0.0 ) ) / 3.0 );
			o.Emission = temp_output_69_0.rgb;
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
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float3 worldPos : TEXCOORD1;
				float3 worldNormal : TEXCOORD2;
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
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
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
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
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
112;162;1215;857;1253.85;689.0719;1.674833;True;False
Node;AmplifyShaderEditor.WorldNormalVector;13;-1649.027,-508.0959;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;8;-1705.053,-311.1424;Inherit;True;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;14;-1251.889,-398.5062;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;43;-1084.235,48.56874;Inherit;True;SRP Additional Light;-1;;11;6c86746ad131a0a408ca599df5f40861;3,6,0,9,1,23,1;5;2;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;15;FLOAT3;0,0,0;False;14;FLOAT3;1,1,1;False;18;FLOAT;0.5;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;38;-958.3174,-423.9896;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;41;-615.1728,-478.6919;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;17;-322.5942,-314.2499;Inherit;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;67;-254.0078,635.7215;Inherit;False;Constant;_Float2;Float 2;5;0;Create;True;0;0;False;0;False;0.8;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-324.7283,241.4465;Inherit;False;Property;_Float0;Float 0;0;0;Create;True;0;0;False;0;False;0.62;0.63;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;48;-332.65,-75.45421;Inherit;False;Property;_Float1;Float 1;1;0;Create;True;0;0;False;0;False;0.1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;46;-80.12825,161.3721;Inherit;True;Step Antialiasing;-1;;15;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;49;-607.0522,236.7874;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.FunctionNode;66;-37.29382,599.6011;Inherit;False;Step Antialiasing;-1;;13;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;51;-83.82896,-268.8701;Inherit;True;Step Antialiasing;-1;;14;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;204.2366,-239.4684;Inherit;True;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;166.4074,424.272;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;19;164.2793,-450.724;Inherit;False;Constant;_Basecolor;Base color;1;0;Create;True;0;0;False;0;False;0.1880476,0,0.3113208,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;149.4998,55.07664;Inherit;True;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;70;724.7402,-118.3483;Inherit;False;Constant;_Float3;Float 3;5;0;Create;True;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;50;553.2216,-331.69;Inherit;True;4;4;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;COLOR;0,0,0,0;False;3;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LightAttenuation;32;-1077.89,-187.2051;Inherit;True;0;1;FLOAT;0
Node;AmplifyShaderEditor.ObjSpaceLightDirHlpNode;40;-1606.999,268.2902;Inherit;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleDivideOpNode;69;880.7992,-278.8823;Inherit;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;80;-834.283,-111.9597;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;81;1336.974,-429.6367;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;SHADER;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;14;0;13;0
WireConnection;14;1;8;0
WireConnection;38;0;14;0
WireConnection;41;0;38;0
WireConnection;41;1;43;0
WireConnection;17;0;41;0
WireConnection;46;1;17;0
WireConnection;46;2;16;0
WireConnection;66;1;17;0
WireConnection;66;2;67;0
WireConnection;51;1;17;0
WireConnection;51;2;48;0
WireConnection;57;0;49;1
WireConnection;57;1;51;0
WireConnection;57;2;49;2
WireConnection;68;0;66;0
WireConnection;68;1;49;1
WireConnection;68;2;49;2
WireConnection;56;0;49;1
WireConnection;56;1;46;0
WireConnection;56;2;49;2
WireConnection;50;0;57;0
WireConnection;50;1;56;0
WireConnection;50;2;19;0
WireConnection;50;3;68;0
WireConnection;69;0;50;0
WireConnection;69;1;70;0
WireConnection;80;0;32;0
WireConnection;80;1;43;0
WireConnection;81;0;19;0
WireConnection;81;2;69;0
WireConnection;81;13;69;0
ASEEND*/
//CHKSM=D2A0B7A7CF9CE5BD68523BE29CBE38BC5039EF75