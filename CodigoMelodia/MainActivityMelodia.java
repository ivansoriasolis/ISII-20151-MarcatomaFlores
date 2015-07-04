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

class this._cls0 extends TimerTask
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
                    runOnUiThread(new Runnable() {

                        final MainActivity._cls1 this$1;

                        public void run()
                        {
                            MainActivity.access$4(this$0).setImageBitmap(MainActivity.access$5(this$0));
                        }

            
            {
                this$1 = MainActivity._cls1.this;
                super();
            }
                    });
                }
                MainActivity.access$6(MainActivity.this, aflag);
                return;
            }
            aflag[i] = MainActivity.access$0(MainActivity.this)[i].isPlaying();
            i++;
        } while (true);
    }


    _cls1.this._cls1()
    {
        this$0 = MainActivity.this;
        super();
    }
}
