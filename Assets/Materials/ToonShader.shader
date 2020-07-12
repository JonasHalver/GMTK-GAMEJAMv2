// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ToonShader"
{
	Properties
	{
		_MainColor("MainColor", Color) = (0.3773585,0.3773585,0.3773585,0)
		_Float0("Float 0", Float) = 0.1
		_Float1("Float 1", Float) = 0.5
		_8(",8", Float) = 0.8
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf StandardCustomLighting keepalpha addshadow fullforwardshadows 
		struct Input
		{
			half filler;
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

		uniform float4 _MainColor;
		uniform float _8;
		uniform float _Float1;
		uniform float _Float0;

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
			float temp_output_101_0 = ( 1.0 - ase_lightAtten );
			float temp_output_3_0_g11 = ( _8 - temp_output_101_0 );
			float temp_output_3_0_g13 = ( _Float1 - temp_output_101_0 );
			float temp_output_3_0_g12 = ( _Float0 - temp_output_101_0 );
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			c.rgb = ( ( ( saturate( ( temp_output_3_0_g11 / fwidth( temp_output_3_0_g11 ) ) ) + saturate( ( temp_output_3_0_g13 / fwidth( temp_output_3_0_g13 ) ) ) + saturate( ( temp_output_3_0_g12 / fwidth( temp_output_3_0_g12 ) ) ) ) / 3.0 ) * ( ase_lightColor * ase_lightAtten ) ).rgb;
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
			o.Emission = _MainColor.rgb;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18200
45;364;1527;382;302.3868;403.0995;2.112912;True;False
Node;AmplifyShaderEditor.LightAttenuation;98;1980.205,307.8571;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;101;1031.649,-213.5415;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;103;1134.272,-38.30626;Inherit;False;Property;_Float1;Float 1;2;0;Create;True;0;0;False;0;False;0.5;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;105;1148.483,224.3802;Inherit;False;Property;_8;,8;3;0;Create;True;0;0;False;0;False;0.8;0.06;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;100;1016.847,-338.313;Inherit;False;Property;_Float0;Float 0;1;0;Create;True;0;0;False;0;False;0.1;0.95;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;72;1912.85,101.3512;Inherit;False;812;304;Comment;2;89;84;Attenuation and Ambient;1,1,1,1;0;0
Node;AmplifyShaderEditor.FunctionNode;104;1374.028,77.15768;Inherit;True;Step Antialiasing;-1;;11;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;102;1330.238,-208.6593;Inherit;True;Step Antialiasing;-1;;13;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;99;1183.907,-451.2461;Inherit;True;Step Antialiasing;-1;;12;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;106;1685.25,-128.4242;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;84;2024.849,149.3512;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;108;1797.255,-29.59653;Inherit;False;Constant;_Float2;Float 2;5;0;Create;True;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;66;454.1206,-219.8709;Inherit;False;540.401;320.6003;Comment;3;73;71;70;N . L;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;107;1955.379,-90.54028;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;89;2568.85,149.3512;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;61;704.5945,381.7005;Inherit;False;507.201;385.7996;Comment;3;65;63;62;N . V;1,1,1,1;0;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;63;800.5943,589.7007;Float;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;73;854.1206,-107.8709;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;70;566.1206,-171.8709;Inherit;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;71;518.1206,-11.87088;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ColorNode;111;3349.45,-332.2067;Inherit;False;Property;_MainColor;MainColor;0;0;Create;True;0;0;False;0;False;0.3773585,0.3773585,0.3773585,0;0.1129116,0,0.1320755,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DotProductOpNode;65;1056.593,509.7005;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;62;752.5944,429.7005;Inherit;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;93;2955.721,-98.67088;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;60;3716.427,-31.34842;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;ToonShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;101;0;98;0
WireConnection;104;1;101;0
WireConnection;104;2;105;0
WireConnection;102;1;101;0
WireConnection;102;2;103;0
WireConnection;99;1;101;0
WireConnection;99;2;100;0
WireConnection;106;0;104;0
WireConnection;106;1;102;0
WireConnection;106;2;99;0
WireConnection;107;0;106;0
WireConnection;107;1;108;0
WireConnection;89;0;84;0
WireConnection;89;1;98;0
WireConnection;73;0;70;0
WireConnection;73;1;71;0
WireConnection;65;0;62;0
WireConnection;65;1;63;0
WireConnection;93;0;107;0
WireConnection;93;1;89;0
WireConnection;60;2;111;0
WireConnection;60;13;93;0
ASEEND*/
//CHKSM=5E9AB6FE5E71D137E19370C17F421A0A2BB7785A