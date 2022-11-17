Shader "Interface3/TextureBlending" 
{

    Properties 
    {
        _MainTex ("Main Texture", 2D) = "white" {}
        _SecondaryTex ("Secondary Texture", 2D) = "white" {}
        _MaskTex ("Mask Texture", 2D) = "white" {}
        _Cutoff ("Cutoff", Range(0.0,1.0)) = 0
        _TransitionWidth("Transition Width", Range(0.0, 0.002)) = 0.001
        _TransitionStrength("Transition Strength", Range(0.0,10)) = 1

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

            float _Cutoff;
            float _TransitionWidth;
            float _TransitionStrength;


            struct Input 
            { 
                //On récupère dans la struct les coordonnées UV de la texture, équivalent au node SampleTexture2D dans Shader graph
                float2 uv_MainTex;
            };

            void surfaceFunction (Input IN, inout SurfaceOutputStandard OUT)
            {
                //Step = Transition brutale, comme une marche, qui renvoie 0 ou 1 en fonction de la valeur de _Cutoff : si cutoff est en-dessous de 0 -> renvoie 0 et si cutoff est au-dessus de 1 -> renvoie 1
                //m = Valeur qui permet de savoir à quel point on se trouve dans la Main ou la Secondary Tex au point .r
                float m = step(_Cutoff, tex2D(_MaskTex, IN.uv_MainTex).r); //tex2D = SamplerTexture2D, il faut lui donner une texture à lire et à quel point l'observer = la coordonnée uv sur la texture que l'on va aller regarder

                //mx = valeur décalée de 1 à droite du point à observer
                float mx = step(_Cutoff, tex2D(_MaskTex, IN.uv_MainTex + float2(_TransitionWidth, 1)).r);
                float my = step(_Cutoff, tex2D(_MaskTex, IN.uv_MainTex + float2(0, _TransitionWidth)).r);

                //Création des 2 vecteurs, dont on va normaliser la longueur à 1
                float3 vec1 = normalize(float3(_TransitionStrength, 0, m - mx));
                float3 vec2 = normalize(float3(0, _TransitionStrength, m - my));

                //Cross Product des 2 vecteurs créés
                OUT.Normal = cross(vec1, vec2);

                OUT.Albedo = m * tex2D (_MainTex, IN.uv_MainTex).rgb + (1-m) * tex2D (_SecondaryTex, IN.uv_MainTex).rgb;
                //OUT.Albedo = lerp(tex2D (_MainTex, IN.uv_MainTex).rgb, tex2D (_SecondaryTex, IN.uv_MainTex).rgb, m);
            }
        ENDCG

    }
}

//Pop Quizz : coordonnées uv = vont de 0 à 1

//Dot Product de 2 vecteurs = Produit scalaire = produit qui renvoie un NOMBRE entre -1 et 1 de 2 vecteurs sur le même plan
    // 1 = les vecteurs sont parallèles, 0 = les vecteurs sont perpendiculaires, -1 = les vecteurs sont opposés
// Cross Product de 2 vecteurs = renvoie un 3e VECTEUR toujours perpendiculaire aux 2 vecteurs et perpendiculaire au plan