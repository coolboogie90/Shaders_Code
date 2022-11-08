Shader "Interface3/SimpleColor" //Permet de retrouver un menu Interface3 où sont rangés dans un sous-menu tous nos shaders
{
    // Equivalent aux Properties dans Shader Graph (textures, couleurs, paramètres), que l'on va retrouver dans Unity
    Properties 
    {
        // Création d'une couleur, la string = le nom affiché dans Unity
        _MainColor ("Main Color", Color) = (0,1,0,1) //(R,G,B,A) ici, un vert pur, opaque grâce à l'alpha à 1
    }
    
    // Le code qui fait les opération du shader
    SubShader 
    {
        //Utilisation des tags pour dire à Unity QUAND(queue) et COMMENT(RenderType) utiliser notre shader
        //https://docs.unity3d.com/Manual/SL-SubShaderTags.html
        Tags    
        {
            //Queue = Quand = Ordre d'affichage de l'objet
            "Queue" = "Geometry"  
            "RenderType" = "Opaque"
        }

        //HLSL : High Level Shading Language : langage de programmation
        CGPROGRAM
            //Surface Shader : shader qui laisse le soin à Unity de faire tous les calculs de lumière, ne nous laissant que le choix des variables
            // Fonction surf qui utilise le modèle de lumière Lambert (lumière diffuse, qui adoucit les ombres)
            #pragma surface surfaceFunction Lambert 
            
            // On déclare notre couleur dans le subshader à l'aide d'un half4
                //Il est plus optimisé d'utiliser des half que des float, qui prennent la moitié de la place d'un float (ex: float de 16-bit >>> un half de 8-bit)
            half4 _MainColor;

            struct Input 
            { 
                int a;
            };

            void surfaceFunction (Input IN, inout SurfaceOutput OUT)
            {
                //Albedo : propriété physique de l'objet qui correspond à la quantité reflétée de lumière par la surface (+/- mat, +/- glossy)
                OUT.Albedo = _MainColor;
            }
        ENDCG

    }
}

/* ---LEXIQUE---
- Niveau de gris = dans Unity, détermine l'odre de rendering des objets
- Vertex : point géométrique de l'objet
- Fragment : pixel que l'on va dessiner
- World position : utilise le point de pivot du monde
- Object position : utilise le point de pivot de l'objet
- Matrice de projection : liste d'éléments numériques qui suit certaines règles arithmétiques, dans Unity elle représente une transformation spatiale
- Ex : For example, the Built-in shader variable UNITY_MATRIX_MVP refers to the multiplication of three different matrices. M refers to the model matrix, V the view matrix, and P the projection matrix. This matrix is mainly used to transform vertices of an object from object-space to clip-space.
- One Minus = sert par exemple à inverser une texture
- Multiplier par 2 une texture = répéter deux fois la texture sur 1 surface (cf exercice Tiling et Offset dans Shader Graph)
- Texture masque : on crée un float m (pour masque) qui est le résultat masque/texture aux coordonnées qui nous intéressent
    - et notre albedo = un lerp entre les deux tex avec comme 'ratio' m
- Calcul d'un lerp sans passer par la fonction lerp() = m * tex2D(_MainTex, IN.uv_MainTex).rgb + ( 1 - m ) * tex2D(_SecondTex, IN.uv_MainTex).rgb;
- Calcul d'un sin : float m = 0.5*sin(IN.uv_MainTex.x * 50) + 0.5;
    - On rajoute au résultat de notre sinus 0.5 pour que l'on ramène l'intervalle entre 0 et 1 = node Remapping
        - [-1, 1] -> écart de 2 ====>  Nous on veut un écart de 1 = [0,1] !
        - [-1, 1] * 0.5 -> 2 * 0.5  ===> Résultat intermédiaire [-0.5,0.5]
            Ex :- 0.5 * 0.5 -> 0.25
                - -1 *0.5 -> -0.5
        - Enfin on ramène à un écart [0, 1] en ajoutant 0.5 à notre résultat intermédiaire [-0.5, 0.5]
    - Pour trouver un cycle, il faut imaginer que chaque bande = un pic (tex1) ou une vallée(tex2) de notre fonction
        - On multiplie la coordonnée UV par 50 pour retrouver nos pics et vallées (sinon on atteint pas un pic = pi/2 = 1.57)
- Produit scalaire (dot product) entre 2 vecteurs :
    - si parfaitement alignés  = 1
    - si perpendiculaires/orthogonaux = 0
    - si opposés = -1
    - a*b = longueur/normal du vecteur a * longueur/normal du vecteur b * cos theta/de l'angle formé par les 2 vecteurs
        - cos = valeur x de l'angle à un point  
        - sin = valeur y de l'angle à un point
        - cos d'un angle de 90° = 0
    - Dans Unity, nos vecteurs sont normalisés = valent toujours 1 ==> dot(a, b) = cos theta

*/
