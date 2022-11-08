Shader "Interface3/TextureBlending" 
{

    Properties 
    {
        _MainTex ("Main Texture", 2D) = "white" {}
        _SecondaryTex ("Secondary Texture", 2D) = "white" {}
        _MaskTex ("Mask Texture", 2D) = "white" {}
        _Cutoff ("Cutoff", Range(0.0,1.0)) = 0
        //_Occlusion ("Occlusion", Range(0.0,1.0)) = 0

    }
    

    SubShader 
    {

        Tags    
        {
            "Queue" = "Geometry"  
            "RenderType" = "Opaque"
        }

        CGPROGRAM
            #pragma surface surfaceFunction Standard 
            
            sampler2D _MainTex;
            sampler2D _SecondaryTex;
            sampler2D _MaskTex;

            //float _Occlusion;
            float _Cutoff;


            struct Input 
            { 
                //On récupère dans la struct les coordonnées UV de la texture, équivalent au node SampleTexture2D dans Shader graph
                float2 uv_MainTex;
                float2 uv_MaskTex;
            };

            void surfaceFunction (Input IN, inout SurfaceOutputStandard OUT)
            {
                float3 m = tex2D(_MaskTex, IN.uv_MaskTex).r;
                m = step(_Cutoff, m);
                OUT.Albedo = m * tex2D (_MainTex, IN.uv_MainTex).rgb + (1-m) * tex2D (_SecondaryTex, IN.uv_MainTex).rgb;
                //OUT.Albedo = lerp(tex2D (_MainTex, IN.uv_MainTex).rgb, tex2D (_SecondaryTex, IN.uv_MainTex).rgb, m);
                //OUT.Occlusion = _Occlusion;
            }
        ENDCG

    }
}

