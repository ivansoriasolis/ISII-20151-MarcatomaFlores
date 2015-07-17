// Decompiled by Jad v1.5.8e. Copyright 2001 Pavel Kouznetsov.
// Jad home page: http://www.geocities.com/kpdus/jad.html
// Decompiler options: braces fieldsfirst space lnc 

package com.piramox.piano;

import android.app.Activity;
import android.content.Intent;
import android.content.res.Resources;
import android.content.res.TypedArray;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Path;
import android.graphics.Region;
import android.graphics.drawable.Drawable;
import android.media.MediaPlayer;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.Display;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.View;
import android.view.WindowManager;
import android.widget.ImageView;
import android.widget.Toast;
import com.google.android.gms.ads.AdView;
import java.util.Arrays;
import java.util.Timer;
import java.util.TimerTask;

public class MainActivity extends Activity
    implements android.view.View.OnTouchListener
{

    private static final int numBk = 7;
    private static final int numKeys = 18;
    private static final int numWk = 11;
    private int activePointers[];
    private Bitmap bitmap_keyboard;
    private Drawable drawable_black;
    private Drawable drawable_black_press;
    private Drawable drawable_white;
    private Drawable drawable_white_press;
    private ImageView iv;
    private Region kb[];
    private MediaPlayer key[];
    private boolean lastPlayingNotes[];
    private int sh;
    private int sw;
    private Timer timer;

    public MainActivity()
    {
        kb = new Region[18];
        key = new MediaPlayer[18];
        activePointers = new int[18];
    }

    private Bitmap drawKeys()
    {
        Bitmap bitmap;
        Canvas canvas;
        int i;
        bitmap = Bitmap.createBitmap(sw, sh, android.graphics.Bitmap.Config.ARGB_8888);
        canvas = new Canvas(bitmap);
        i = 0;
_L3:
        if (i < 11) goto _L2; else goto _L1
_L1:
        i = 11;
_L4:
        if (i >= 18)
        {
            return bitmap;

        }
        break MISSING_BLOCK_LABEL_113;
_L2:
        if (key[i].isPlaying())
        {
            drawable_white_press.setBounds(kb[i].getBounds());
            drawable_white_press.draw(canvas);
        } else
        {
            drawable_white.setBounds(kb[i].getBounds());
            drawable_white.draw(canvas);
        }
        i++;
          goto _L3
        if (key[i].isPlaying())
        {
            drawable_black_press.setBounds(kb[i].getBounds());
            drawable_black_press.draw(canvas);
        } else
        {
            drawable_black.setBounds(kb[i].getBounds());
            drawable_black.draw(canvas);
        }
        i++;
          goto _L4
    }

    private void makeRegions()
    {
        Path apath[];
        Region region;
        int ai[];
        int i;
        int i1;
        int j1;
        i1 = sw / 11;
        i = (int)((double)sh * 0.80000000000000004D);
        j1 = (int)((double)i1 * 0.59999999999999998D);
        int j = (int)((double)sh * 0.5D);
        apath = new Path[4];
        apath[0] = new Path();
        apath[1] = new Path();
        apath[2] = new Path();
        apath[3] = new Path();
        apath[0].lineTo(0.0F, i);
        apath[0].lineTo(i1, i);
        apath[0].lineTo(i1, j);
        apath[0].lineTo(i1 - j1 / 2, j);
        apath[0].lineTo(i1 - j1 / 2, 0.0F);
        apath[0].close();
        apath[1].moveTo(j1 / 2, 0.0F);
        apath[1].lineTo(j1 / 2, j);
        apath[1].lineTo(0.0F, j);
        apath[1].lineTo(0.0F, i);
        apath[1].lineTo(i1, i);
        apath[1].lineTo(i1, j);
        apath[1].lineTo(i1 - j1 / 2, j);
        apath[1].lineTo(i1 - j1 / 2, 0.0F);
        apath[1].close();
        apath[2].moveTo(j1 / 2, 0.0F);
        apath[2].lineTo(j1 / 2, j);
        apath[2].lineTo(0.0F, j);
        apath[2].lineTo(0.0F, i);
        apath[2].lineTo(i1, i);
        apath[2].lineTo(i1, 0.0F);
        apath[2].close();
        apath[3].addRect(0.0F, 0.0F, j1, j, android.graphics.Path.Direction.CCW);
        region = new Region(0, 0, sw, sh);
        ai = new int[20];
        ai[1] = 1;
        ai[2] = 2;
        ai[4] = 1;
        ai[5] = 1;
        ai[6] = 2;
        ai[8] = 1;
        ai[9] = 2;
        ai[11] = 3;
        ai[12] = 3;
        ai[13] = -1;
        ai[14] = 3;
        ai[15] = 3;
        ai[16] = 3;
        ai[17] = -1;
        ai[18] = 3;
        ai[19] = 3;
        i = 0;
_L3:
        if (i < 11) goto _L2; else goto _L1
_L1:
        int k;
        k = 11;
        i = 11;
_L4:
        if (i >= ai.length)
        {
            return;
        }
        break MISSING_BLOCK_LABEL_548;
_L2:
        kb[i] = new Region();
        Path path = new Path();
        path.addPath(apath[ai[i]], i * i1, 0.0F);
        kb[i].setPath(path, region);
        i++;
          goto _L3
        int l = k;
        if (ai[i] != -1)
        {
            kb[k] = new Region();
            Path path1 = new Path();
            path1.addPath(apath[ai[i]], ((i - 11) + 1) * i1 - j1 / 2, 0.0F);
            kb[k].setPath(path1, region);
            l = k + 1;
        }
        i++;
        k = l;
          goto _L4
    }

    private void playMusic(MediaPlayer mediaplayer)
    {
        mediaplayer.seekTo(0);
        mediaplayer.start();
    }

    private void rateApp()
    {
        Intent intent = new Intent("android.intent.action.VIEW", Uri.parse((new StringBuilder("market://details?id=")).append(getPackageName()).toString()));
        try
        {
            startActivity(intent);
            return;
        }
        catch (Exception exception)
        {
            Toast.makeText(this, "Couldn't launch the market", 1).show();
        }
    }

    private void splayMusic(MediaPlayer mediaplayer)
    {
        mediaplayer.pause();
    }

    protected void onCreate(Bundle bundle)
    {
        int i;
        super.onCreate(bundle);
        requestWindowFeature(1);
        setContentView(0x7f030000);
        bundle = getResources().obtainTypedArray(0x7f0a0000);
        i = 0;
_L3:
        if (i < bundle.length()) goto _L2; else goto _L1
_L1:
        bundle = getResources();
        drawable_white = bundle.getDrawable(0x7f020024);
        drawable_black = bundle.getDrawable(0x7f020001);
        drawable_white_press = bundle.getDrawable(0x7f020025);
        drawable_black_press = bundle.getDrawable(0x7f020002);
        bundle = ((WindowManager)getSystemService("window")).getDefaultDisplay();
        sw = bundle.getWidth();
        sh = bundle.getHeight();
        makeRegions();
        i = 0;
_L4:
        if (i >= 18)
        {
            iv = (ImageView)findViewById(0x7f0c0015);
            iv.setOnTouchListener(this);
            ((AdView)findViewById(0x7f0c0016)).loadAd((new com.google.android.gms.ads.AdRequest.Builder()).build());
            return;
        }
        break MISSING_BLOCK_LABEL_216;
_L2:
        int j = bundle.getResourceId(i, -1);
        if (j != -1)
        {
            key[i] = MediaPlayer.create(this, j);
        } else
        {
            key[i] = null;
        }
        i++;
          goto _L3
        activePointers[i] = -1;
        i++;
          goto _L4
    }

    public boolean onCreateOptionsMenu(Menu menu)
    {
        getMenuInflater().inflate(0x7f0b0000, menu);
        return true;
    }

    public boolean onOptionsItemSelected(MenuItem menuitem)
    {
        menuitem.getItemId();
        JVM INSTR tableswitch 2131492887 2131492887: default 24
    //                   2131492887 26;
           goto _L1 _L2
_L1:
        return true;
_L2:
        rateApp();
        if (true) goto _L1; else goto _L3
_L3:
    }

    protected void onPause()
    {
        super.onPause();
        timer.cancel();
    }

    protected void onResume()
    {
        super.onResume();
        timer = new Timer();
        timer.schedule(new TimerTask() {

            final MainActivity this$0;

            public void run()
            {
                boolean aflag[] = new boolean[18];
                int i = 0;
                do
                {
                    if (i >= aflag.length)
                    {
                        if (!Arrays.equals(aflag, lastPlayingNotes))
                        {
                            bitmap_keyboard = drawKeys();
                            runOnUiThread(new Runnable() {

                                final _cls1 this$1;

                                public void run()
                                {
                                    iv.setImageBitmap(bitmap_keyboard);
                                }

            
            {
                this$1 = _cls1.this;
                super();
            }
                            });
                        }
                        lastPlayingNotes = aflag;
                        return;
                    }
                    aflag[i] = key[i].isPlaying();
                    i++;
                } while (true);
            }


            
            {
                this$0 = MainActivity.this;
                super();
            }
        }, 0L, 100L);
    }

    public boolean onTouch(View view, MotionEvent motionevent)
    {
        float f;
        float f1;
        int i;
        int j;
        j = motionevent.getActionIndex();
        f = motionevent.getX(j);
        f1 = motionevent.getY(j);
        i = 0;
_L8:
        if (i >= 18)
        {
            return true;
        }
        if (!kb[i].contains((int)f, (int)f1)) goto _L2; else goto _L1
_L1:
        Log.d("notes", String.valueOf(i));
        motionevent.getActionMasked();
        JVM INSTR tableswitch 0 6: default 108
    //                   0 117
    //                   1 140
    //                   2 162
    //                   3 108
    //                   4 108
    //                   5 117
    //                   6 140;
           goto _L3 _L4 _L5 _L6 _L3 _L3 _L4 _L5
_L6:
        break MISSING_BLOCK_LABEL_162;
_L3:
        break; /* Loop/switch isn't completed */
_L4:
        break; /* Loop/switch isn't completed */
_L2:
        i++;
        if (true) goto _L8; else goto _L7
_L7:
        playNote(key[i]);
        activePointers[j] = i;
          goto _L2
_L5:
        stopNote(key[i]);
        activePointers[j] = -1;
          goto _L2
        if (activePointers[j] != i)
        {
            if (activePointers[j] != -1)
            {
                stopNote(key[activePointers[j]]);
            }
            playNote(key[i]);
            activePointers[j] = i;
        }
          goto _L2
    }
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








}
