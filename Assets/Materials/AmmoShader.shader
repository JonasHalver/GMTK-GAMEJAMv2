// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AmmoShader"
{
	Properties
	{
		_Vector1("Vector 1", Vector) = (1,2,0,0)
		_MainTex("MainTex", 2D) = "white" {}
		[HDR]_Color0("Color 0", Color) = (0.0690136,1,0,0)
		_Speed2(",", Float) = 0.1
		_AmmoAmount("AmmoAmount", Range( 11 , 100)) = 0.7520621
		_Direction("Direction", Vector) = (0,1,0,0)
		_Float5("Float 5", Float) = -0.59
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_Float4("Float 4", Float) = 6.3
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
			float4 screenPos;
		};

		uniform float4 _Color0;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float _AmmoAmount;
		uniform float _Float4;
		uniform float _Float5;
		uniform sampler2D _TextureSample1;
		uniform float _Speed2;
		uniform float2 _Direction;
		uniform float2 _Vector1;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Emission = _Color0.rgb;
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode1 = tex2D( _MainTex, uv_MainTex );
			float2 uv_TexCoord14 = i.uv_texcoord + float2( 0.34,-0.29 );
			float temp_output_3_0_g1 = ( ( _AmmoAmount / 33.0 ) - ( 1.0 - ( ( atan2( ( uv_TexCoord14.x - 0.5 ) , ( uv_TexCoord14.y - 0.5 ) ) / _Float4 ) + _Float5 ) ) );
			float temp_output_32_0 = saturate( ( temp_output_3_0_g1 / fwidth( temp_output_3_0_g1 ) ) );
			float mulTime47 = _Time.y * _Speed2;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float2 panner49 = ( mulTime47 * _Direction + ( ase_screenPosNorm * float4( _Vector1, 0.0 , 0.0 ) ).xy);
			float4 color57 = IsGammaSpace() ? float4(1,1,1,0) : float4(1,1,1,0);
			float4 lerpResult56 = lerp( tex2D( _TextureSample1, panner49 ) , color57 , 0.64);
			o.Alpha = ( ( ( tex2DNode1.a * ( 1.0 - temp_output_32_0 ) * 0.1 ) + ( tex2DNode1.a * temp_output_32_0 ) ) * lerpResult56 ).r;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows 

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
				float4 screenPos : TEXCOORD3;
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
				o.screenPos = ComputeScreenPos( o.pos );
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
				surfIN.screenPos = IN.screenPos;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
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
26;549;1918;484;2262.977;-54.5347;1.536032;True;True
Node;AmplifyShaderEditor.Vector2Node;12;-619.0809,141.7536;Inherit;False;Constant;_Vector0;Vector 0;4;0;Create;True;0;0;False;0;False;0.34,-0.29;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;14;-2959.085,35.45368;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;13;-2660.097,82.87562;Inherit;False;Constant;_Float1;Float 1;4;0;Create;True;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;16;-2454.789,-138.6172;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;15;-2488.328,123.457;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ATan2OpNode;17;-2120.597,56.87574;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;18;-1848.897,128.3758;Inherit;True;True;True;True;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-1673.397,410.476;Inherit;False;Property;_Float4;Float 4;8;0;Create;True;0;0;False;0;False;6.3;2.57;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-1367.225,445.4824;Inherit;False;Property;_Float5;Float 5;6;0;Create;True;0;0;False;0;False;-0.59;-0.55;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;23;-1530.397,163.4757;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-1278.109,702.8853;Inherit;False;Constant;_Float3;Float 3;3;0;Create;True;0;0;False;0;False;33;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-1365.973,598.2389;Inherit;False;Property;_AmmoAmount;AmmoAmount;4;0;Create;True;0;0;False;0;False;0.7520621;31.9;11;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;29;-1082.299,254.5092;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;44;23.47275,629.4341;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;45;35.32275,865.1466;Inherit;False;Property;_Vector1;Vector 1;0;0;Create;True;0;0;False;0;False;1,2;1,-0.16;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.OneMinusNode;31;-812.4006,284.1396;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-48.12054,1340.124;Inherit;False;Property;_Speed2;,;3;0;Create;True;0;0;False;0;False;0.1;-0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;30;-1048.057,626.7142;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;32;-559.0221,301.0769;Inherit;True;Step Antialiasing;-1;;1;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;229.9135,756.2558;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleTimeNode;47;99.14145,1340.529;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;46;98.14145,1200.528;Inherit;False;Property;_Direction;Direction;5;0;Create;True;0;0;False;0;False;0,1;0,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;49;451.8414,1151.428;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;37;79.56165,155.3257;Inherit;False;Constant;_Float2;Float 2;5;0;Create;True;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-493.5445,-115.0428;Inherit;True;Property;_MainTex;MainTex;1;0;Create;True;0;0;False;0;False;-1;b5d754785ca6a724c9cbf47e7bb21e81;b5d754785ca6a724c9cbf47e7bb21e81;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;38;-10.96598,81.42355;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;50;653.376,747.6069;Inherit;True;Property;_TextureSample1;Texture Sample 1;7;0;Create;True;0;0;False;0;False;-1;8a19edd2b05875640820cefab99e4e53;c707a33d5ba2eb845be2eaf08bf739e4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-314.0489,330.8379;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;58;926.4512,1071.361;Inherit;False;Constant;_Float6;Float 6;10;0;Create;True;0;0;False;0;False;0.64;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;247.4166,37.08599;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;57;719.8013,990.496;Inherit;False;Constant;_Color2;Color 2;10;0;Create;True;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;56;1070.936,888.4844;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;41;-35.62067,318.9508;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;52;-172.4815,1076.177;Inherit;False;Property;_Tiling;Tiling;9;0;Create;True;0;0;False;0;False;1,1;1,2.22;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;1019.409,354.1895;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;53;34.14145,1067.528;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;4;1034.492,-160.6138;Inherit;False;Property;_Color0;Color 0;2;1;[HDR];Create;True;0;0;False;0;False;0.0690136,1,0,0;0.0690136,1,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1308.677,-178.1786;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;AmmoShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;14;1;12;0
WireConnection;16;0;14;1
WireConnection;16;1;13;0
WireConnection;15;0;14;2
WireConnection;15;1;13;0
WireConnection;17;0;16;0
WireConnection;17;1;15;0
WireConnection;18;0;17;0
WireConnection;23;0;18;0
WireConnection;23;1;19;0
WireConnection;29;0;23;0
WireConnection;29;1;20;0
WireConnection;31;0;29;0
WireConnection;30;0;27;0
WireConnection;30;1;28;0
WireConnection;32;1;31;0
WireConnection;32;2;30;0
WireConnection;48;0;44;0
WireConnection;48;1;45;0
WireConnection;47;0;43;0
WireConnection;49;0;48;0
WireConnection;49;2;46;0
WireConnection;49;1;47;0
WireConnection;38;0;32;0
WireConnection;50;1;49;0
WireConnection;10;0;1;4
WireConnection;10;1;32;0
WireConnection;42;0;1;4
WireConnection;42;1;38;0
WireConnection;42;2;37;0
WireConnection;56;0;50;0
WireConnection;56;1;57;0
WireConnection;56;2;58;0
WireConnection;41;0;42;0
WireConnection;41;1;10;0
WireConnection;55;0;41;0
WireConnection;55;1;56;0
WireConnection;53;0;52;0
WireConnection;0;2;4;0
WireConnection;0;9;55;0
ASEEND*/
//CHKSM=DC9C917B31AE98FB24251DDAF82577E86888A752