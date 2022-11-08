Shader "Interface3/SimpleLambert" //Permet de retrouver un menu Interface3 où sont rangés dans un sous-menu tous nos shaders
{
    Properties 
    {
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
            #pragma surface surfaceFunction SimpleLambert 
            
            half4 _MainColor;

            struct Input 
            { 
                int a;
            };

            void surfaceFunction (Input IN, inout SurfaceOutput OUT)
            {
                OUT.Albedo = _MainColor;
            }

            half4 LightingSimpleLambert(SurfaceOutput surface, half3 lightDir, half atten) //atten = atténuation de la lumière
            {
                //NdotL = normal dot product de la Lumière
                //saturate = clamp entre 0 et 1, pour éviter que ça monte au-dessus/va en-dessous
                half NdotL = saturate(dot(surface.Normal, lightDir));
                //Si on veut éclairer notre objet de manière opposée à la lumière : half NdotL = saturate(-dot(surface.Normal, lightDir));

                half4 color;
                //_LightColor0.rgb = couleur de la lumière
                color.rgb = surface.Albedo * _LightColor0.rgb * NdotL * atten;
                color.a = surface.Alpha;    // permet de dire que la lumière ne change pas la transparence déjà calculée par la surface
                
                return color;
            }


        ENDCG

    }
}

