Shader "Interface3/SimpleTexture" 
{

    Properties 
    {
        _MainTex ("Main Texture", 2D) = "white" {}
        _MainColor ("Main Color", Color) = (0,1,0,1) //(R,G,B,A) ici, un vert pur, opaque grâce à l'alpha à 1
    }
    

    SubShader 
    {

        Tags    
        {
            "Queue" = "Geometry"  
            "RenderType" = "Opaque"
        }

        CGPROGRAM
            #pragma surface surfaceFunction Lambert 
            
            sampler2D _MainTex;
            half4 _MainColor;

            struct Input 
            { 
                //On récupère dans la struct les coordonnées UV de la texture, équivalent au node SampleTexture2D dans Shader graph
                float2 uv_MainTex;
            };

            void surfaceFunction (Input IN, inout SurfaceOutput OUT)
            {
                //Albedo = couleur de base d'une surface = escription de la lumière réfléchie par l'objet, ce que nous percevons comme sa couleur
                //Renvoie un float4
                OUT.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb * _MainColor;

                    /* float4 vector = (1,2,3,4)
                    vector.rgb -> (1,2,3)
                    vector.y -> (2)
                    --Swizzling---
                    vector.xxy -> (1,1,2)
                    */
            }
        ENDCG

    }
}

