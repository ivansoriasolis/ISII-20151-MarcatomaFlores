// Decompiled by Jad v1.5.8e. Copyright 2001 Pavel Kouznetsov.
// Jad home page: http://www.geocities.com/kpdus/jad.html
// Decompiler options: braces fieldsfirst space lnc 

package com.piramox.piano;

import android.media.MediaPlayer;
import android.widget.ImageView;
import java.util.Arrays;
import java.util.TimerTask;

// Referenced classes of package com.piramox.piano:
//            MainActivity

class this._cls1
    implements Runnable
{

    final is._cls0 this$1;

    public void run()
    {
        MainActivity.access$4(_fld0).setImageBitmap(MainActivity.access$5(_fld0));
    }

    is._cls0()
    {
        this$1 = this._cls1.this;
        super();
    }

    // Unreferenced inner class com/piramox/piano/MainActivity$1

/* anonymous class */
    class MainActivity._cls1 extends TimerTask
    {

        final MainActivity this$0;

        public void run()
        {
            boolean aflag[] = new boolean[18];
            int i = 0;
            do
            {
                if (i >= aflag.length)
                {
                    if (!Arrays.equals(aflag, MainActivity.access$1(MainActivity.this)))
                    {
                        MainActivity.access$3(MainActivity.this, MainActivity.access$2(MainActivity.this));
                        runOnUiThread(new MainActivity._cls1._cls1());
                    }
                    MainActivity.access$6(MainActivity.this, aflag);
                    return;
                }
                aflag[i] = MainActivity.access$0(MainActivity.this)[i].isPlaying();
                i++;
            } while (true);
        }


            
            {
                this$0 = MainActivity.this;
                super();
            }
    }

}
