texture TEXTURE_REMAP;

technique TexReplace
{
    pass P0
    {
        Texture[0] = TEXTURE_REMAP;
    }
}