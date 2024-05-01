This is a script to generate Teardown skybox DDS files.

The example skybox is made by GregZaal and can be donwloaded (among others) here:
https://hdrihaven.com/hdri/?c=outdoor&h=kloofendal_48d_partly_cloudy

Running the script "generate.bat" will generate a .dds file that can be used in the game.
Place the .dds file in your mod folder and use that in the skybox property on environment node:

skybox=MOD/sky.dds
