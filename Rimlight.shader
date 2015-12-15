Shader "Rim/Light Specular With Alpha Double Face" {
Properties {
_Color ("Main Color", Color) = (1,1,1,1)
_MainTex ("Texture", 2D) = "white" {}
_BumpMap ("Normalmap", 2D) = "bump" {}
_RimColor ("Rim Color", Color) = (0.26,0.19,0.16,0.0)
_RimPower ("Rim Power", Range(0.5,8.0)) = 3.0

}
SubShader {
Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
cull off

  Pass {
        ZWrite On
        ColorMask 0
    }
CGPROGRAM
#pragma surface surf Lambert alpha
struct Input {
float2 uv_MainTex;
float3 worldRefl;
float3 viewDir;
float2 uv_BumpMap;
INTERNAL_DATA
};
sampler2D _MainTex;
sampler2D _BumpMap;
float4 _RimColor;
fixed4 _Color;
float _RimPower;

void surf (Input IN, inout SurfaceOutput o) {
o.Alpha = _Color.a ;

o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb;
o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
half rim = 1.0 - saturate(dot (normalize(IN.viewDir), o.Normal));
o.Emission =_Color.rgb*tex2D (_MainTex, IN.uv_MainTex).rgb+ _RimColor.rgb * pow (rim, _RimPower) ;

}
ENDCG
}
Fallback "Transparent/Diffuse"
} 