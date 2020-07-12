// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ScanLines"
{
	Properties
	{
		[HDR]_Color0("Color 0", Color) = (0.1167121,1,0,0)
		_Speed(",", Float) = 0.1
		_Direction("Direction", Vector) = (0,1,0,0)
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_MainTex("MainTex", 2D) = "white" {}
		_blinkSpeed("blinkSpeed", Float) = 80
		_Float1("Float 1", Float) = 6.75
		_Float2("Float 2", Float) = 20
		_Tiling("Tiling", Vector) = (1,1,0,0)
		_Float0("Float 0", Float) = 0.5
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
		};

		uniform float4 _Color0;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform sampler2D _TextureSample0;
		uniform float _Speed;
		uniform float2 _Direction;
		uniform float2 _Tiling;
		uniform float _blinkSpeed;
		uniform float _Float1;
		uniform float _Float2;
		uniform float _Float0;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Emission = _Color0.rgb;
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode2 = tex2D( _MainTex, uv_MainTex );
			float mulTime7 = _Time.y * _Speed;
			float2 uv_TexCoord4 = i.uv_texcoord * _Tiling;
			float2 panner3 = ( mulTime7 * _Direction + uv_TexCoord4);
			float mulTime52 = _Time.y * _blinkSpeed;
			o.Alpha = ( tex2DNode2.a * ( tex2D( _TextureSample0, panner3 ) + ( saturate( ( ( sin( mulTime52 ) + _Float1 ) / _Float2 ) ) * _Float0 ) ) ).r;
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
203;259;1165;551;2203.896;793.4343;2.717413;True;False
Node;AmplifyShaderEditor.RangedFloatNode;54;-888.3491,243.9137;Inherit;False;Property;_blinkSpeed;blinkSpeed;5;0;Create;True;0;0;False;0;False;80;60;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;52;-729.0887,241.2014;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;53;-567.7163,239.8456;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;56;-631.5398,379.7327;Inherit;False;Property;_Float1;Float 1;6;0;Create;True;0;0;False;0;False;6.75;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;59;-402.5516,422.759;Inherit;False;Property;_Float2;Float 2;7;0;Create;True;0;0;False;0;False;20;-0.02;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-984.762,49.09531;Inherit;False;Property;_Speed;,;1;0;Create;True;0;0;False;0;False;0.1;-0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;64;-1109.123,-214.851;Inherit;False;Property;_Tiling;Tiling;8;0;Create;True;0;0;False;0;False;1,1;1,2.22;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;55;-409.056,271.035;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;58;-237.7959,260.9792;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;6;-838.5,-90.5;Inherit;False;Property;_Direction;Direction;2;0;Create;True;0;0;False;0;False;0,1;0,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;7;-837.5,49.5;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-902.5,-223.5;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;57;-93.0204,257.6306;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;3;-639.5,-117.5;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;61;43.06726,461.4375;Inherit;False;Property;_Float0;Float 0;9;0;Create;True;0;0;False;0;False;0.5;0.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-424.5,-133.5;Inherit;True;Property;_TextureSample0;Texture Sample 0;3;0;Create;True;0;0;False;0;False;-1;8a19edd2b05875640820cefab99e4e53;c707a33d5ba2eb845be2eaf08bf739e4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;147.3998,266.0211;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-335.7726,-359.5652;Inherit;True;Property;_MainTex;MainTex;4;0;Create;True;0;0;False;0;False;-1;8a19edd2b05875640820cefab99e4e53;8a19edd2b05875640820cefab99e4e53;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;40;418.4428,-55.6765;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComputeScreenPosHlpNode;67;-1633.963,30.24577;Inherit;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.UnityObjToClipPosHlpNode;66;-1894.296,-24.56122;Inherit;False;1;0;FLOAT3;0,0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;228.5577,-328.3452;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;724.1238,-91.85513;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldPosInputsNode;71;-857.372,-412.3033;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PosVertexDataNode;65;-2220.854,-51.96473;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;5;-399.3,-539.2999;Inherit;False;Property;_Color0;Color 0;0;1;[HDR];Create;True;0;0;False;0;False;0.1167121,1,0,0;0.517961,2,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;69;-1245.747,71.35124;Inherit;True;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ComponentMaskNode;68;-1446.706,187.8161;Inherit;False;True;True;True;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;47;879.8582,-258.7298;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;ScanLines;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;52;0;54;0
WireConnection;53;0;52;0
WireConnection;55;0;53;0
WireConnection;55;1;56;0
WireConnection;58;0;55;0
WireConnection;58;1;59;0
WireConnection;7;0;8;0
WireConnection;4;0;64;0
WireConnection;57;0;58;0
WireConnection;3;0;4;0
WireConnection;3;2;6;0
WireConnection;3;1;7;0
WireConnection;1;1;3;0
WireConnection;60;0;57;0
WireConnection;60;1;61;0
WireConnection;40;0;1;0
WireConnection;40;1;60;0
WireConnection;67;0;66;0
WireConnection;66;0;65;0
WireConnection;9;0;2;0
WireConnection;46;0;2;4
WireConnection;46;1;40;0
WireConnection;69;0;67;0
WireConnection;69;1;68;0
WireConnection;68;0;67;0
WireConnection;47;2;5;0
WireConnection;47;9;46;0
ASEEND*/
//CHKSM=5AA565C9A54CD3B798C1EEF8BF5094F40DEC0B07