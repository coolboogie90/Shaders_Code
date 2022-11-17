Shader "Interface3/SimplePBR" 
{

    Properties 
    {
        _MainTex ("Main Texture", 2D) = "white" {}
        _MainColor ("Main Color", Color) = (0,1,0,1) //(R,G,B,A) ici, un vert pur, opaque grâce à l'alpha à 1
        _Metallic ("Metallic", Range(0.0,1.0)) = 0
        _Smoothness ("Smoothness", Range(0.0,1.0)) = 0
    }
    

    SubShader 
    {

        Tags    
        {
            "Queue" = "Geometry"  
            "RenderType" = "Opaque"
        }

        CGPROGRAM
            #pragma surface surfaceFunction Standard fullforwardshadows
            #pragma target 3.0 
            //target 3.0 si on a un shader un peu fancy/coûteux pour des machines plus anciennes
            
            sampler2D _MainTex;
            half4 _MainColor;
            float _Metallic;
            float _Smoothness;

            struct Input 
            { 
                //On récupère dans la struct les coordonnées UV de la texture, équivalent au node SampleTexture2D dans Shader graph
                float2 uv_MainTex;
            };

            void surfaceFunction (Input IN, inout SurfaceOutputStandard OUT)
            {
                OUT.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb * _MainColor;
                OUT.Metallic = _Metallic;
                OUT.Smoothness = _Smoothness;
            }
        ENDCG

    }
}

