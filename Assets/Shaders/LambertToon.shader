Shader "Interface3/LambertToon" //Permet de retrouver un menu Interface3 où sont rangés dans un sous-menu tous nos shaders
{
    Properties 
    {
        _MainTex ("Main Texture", 2D) = "white" {}
        _MainColor ("Main Color", Color) = (0,1,0,1) //(R,G,B,A) ici, un vert pur, opaque grâce à l'alpha à 1
        _ToonRamp ("Toon Ramp", 2D) = "white" {}
    }
    
    SubShader 
    {
        Tags    
        {
            "Queue" = "Geometry"  
            "RenderType" = "Opaque"
        }

        CGPROGRAM
            #pragma surface surfaceFunction LambertToon 
            
            half4 _MainColor;
            sampler2D _ToonRamp;
            sampler2D _MainTex;

            struct Input 
            { 
                half2 uv_MainTex;
            };

            void surfaceFunction (Input IN, inout SurfaceOutput OUT)
            {
                OUT.Albedo = _MainColor * tex2D (_MainTex, IN.uv_MainTex).rgb;
            }

            half4 LightingLambertToon (SurfaceOutput surface, half3 lightDir, half atten) //atten = atténuation de la lumière
            {
                half NdotL = saturate(dot(surface.Normal, lightDir));
                half lightStrength = tex2D(_ToonRamp, half2(NdotL, 0.5));
                half4 color;
                color.rgb = surface.Albedo * _LightColor0.rgb * lightStrength * atten;
                color.a = surface.Alpha;    
                return color;
            }


        ENDCG

    }
}

