// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ObjShader"
{
	Properties
	{
		_Float3("Float 3", Float) = 0.1
		_Float0("Float 0", Float) = 0.5
		_8(",8", Float) = 0.8
		_Glow("Glow", Color) = (0.8177759,0.3443396,1,0)
		_LightAmount("LightAmount", Float) = 0
		_Color("Color", Color) = (0,0,0,0)
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf StandardCustomLighting keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
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

		uniform float4 _Color;
		uniform float4 _Glow;
		uniform float _8;
		uniform float _Float0;
		uniform float _Float3;
		uniform float _LightAmount;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertexNormal = v.normal.xyz;
			v.normal = ase_vertexNormal;
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
			float temp_output_5_0 = ( 1.0 - ase_lightAtten );
			float temp_output_3_0_g32 = ( _8 - temp_output_5_0 );
			float temp_output_3_0_g33 = ( _Float0 - temp_output_5_0 );
			float temp_output_3_0_g31 = ( _Float3 - temp_output_5_0 );
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			c.rgb = ( _Color * ( saturate( ( ( saturate( ( temp_output_3_0_g32 / fwidth( temp_output_3_0_g32 ) ) ) + saturate( ( temp_output_3_0_g33 / fwidth( temp_output_3_0_g33 ) ) ) + saturate( ( temp_output_3_0_g31 / fwidth( temp_output_3_0_g31 ) ) ) ) / 3.0 ) ) * ( ase_lightColor * ase_lightAtten ) * _LightAmount ) ).rgb;
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
			float4 temp_output_50_0 = _Color;
			o.Albedo = temp_output_50_0.rgb;
			o.Emission = _Glow.rgb;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18200
0;31;1920;988;2442.852;398.7099;1.680173;True;False
Node;AmplifyShaderEditor.CommentaryNode;1;-1940.543,904.1152;Inherit;False;812;304;Comment;3;35;27;46;Attenuation and Ambient;1,1,1,1;0;0
Node;AmplifyShaderEditor.LightAttenuation;46;-1833.834,1110.719;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-2597.282,811.8892;Inherit;False;Property;_8;,8;2;0;Create;True;0;0;False;0;False;0.8;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-2611.493,549.2023;Inherit;False;Property;_Float0;Float 0;1;0;Create;True;0;0;False;0;False;0.5;0.82;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;5;-2714.116,373.9673;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2;-2728.918,249.1957;Inherit;False;Property;_Float3;Float 3;0;0;Create;True;0;0;False;0;False;0.1;0.67;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;6;-2561.858,136.2628;Inherit;True;Step Antialiasing;-1;;31;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;7;-2371.737,664.6663;Inherit;True;Step Antialiasing;-1;;32;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;9;-2415.527,378.8495;Inherit;True;Step Antialiasing;-1;;33;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;13;-1908.998,395.0807;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-1709.817,516.8495;Inherit;False;Constant;_Float2;Float 2;5;0;Create;True;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;27;-1809.226,935.5572;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleDivideOpNode;26;-1541.929,478.847;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;32;-1235.475,496.1048;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;47;-1017.848,995.3932;Inherit;False;Property;_LightAmount;LightAmount;4;0;Create;True;0;0;False;0;False;0;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-1284.542,952.1152;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;36;-3291.645,367.6379;Inherit;False;540.401;320.6003;Comment;3;41;38;37;N . L;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;34;-3041.171,969.2092;Inherit;False;507.201;385.7996;Comment;3;45;43;40;N . V;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;-905.7689,431.8654;Inherit;True;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;50;-782.652,-213.8015;Inherit;False;Property;_Color;Color;5;0;Create;True;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;18;-789.8957,29.6505;Inherit;False;Property;_Glow;Glow;3;0;Create;True;0;0;False;0;False;0.8177759,0.3443396,1,0;0.0536949,0.01837842,0.06603771,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldNormalVector;45;-2993.17,1017.209;Inherit;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;40;-2945.171,1177.209;Float;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;43;-2689.172,1097.209;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;38;-3227.645,575.6377;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;41;-3179.644,415.6379;Inherit;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;37;-2891.644,479.6378;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;44;-516.2863,582.6862;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;-453.5273,231.3549;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,-2;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;ObjShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;5;0;46;0
WireConnection;6;1;5;0
WireConnection;6;2;2;0
WireConnection;7;1;5;0
WireConnection;7;2;3;0
WireConnection;9;1;5;0
WireConnection;9;2;4;0
WireConnection;13;0;7;0
WireConnection;13;1;9;0
WireConnection;13;2;6;0
WireConnection;26;0;13;0
WireConnection;26;1;14;0
WireConnection;32;0;26;0
WireConnection;35;0;27;0
WireConnection;35;1;46;0
WireConnection;42;0;32;0
WireConnection;42;1;35;0
WireConnection;42;2;47;0
WireConnection;43;0;45;0
WireConnection;43;1;40;0
WireConnection;37;0;41;0
WireConnection;37;1;38;0
WireConnection;51;0;50;0
WireConnection;51;1;42;0
WireConnection;0;0;50;0
WireConnection;0;2;18;0
WireConnection;0;13;51;0
WireConnection;0;12;44;0
ASEEND*/
//CHKSM=E9D42244514B70CCB2BB941A734F9725AAC6D09D