# Finding Your Supabase Service Role Key

## Option 1: Via Supabase Dashboard (Most Common)

1. Go to your Supabase project: https://app.supabase.com/project/wmumpqvvoydngcbffozu
2. Click on **Settings** (gear icon in left sidebar)
3. Click on **API** in the settings menu
4. Scroll down to the **Project API keys** section
5. Look for **service_role** key (under "Project API keys" or similar section)

**Note**: The service_role key is different from the `anon` key you already have!

---

## Option 2: Alternative - Use Manual Upload in Dashboard

If you can't find the service role key, you can manually upload images:

### Step 1: Download the Vehicle Images

The script will download images to a temporary folder. Run:

```bash
# First, let's create a script to just download images
node scripts/download-images-only.js
```

### Step 2: Upload via Supabase Dashboard

1. Go to: https://app.supabase.com/project/wmumpqvvoydngcbffozu/storage
2. Click on the `vehicle-images` bucket (after running migration)
3. Click **Upload** button
4. Upload the images one by one:
   - `tesla-model-3.jpg`
   - `tesla-model-y.jpg`
   - `byd-atto-3.jpg`
   - `byd-han-plus.jpg`
   - `nio-es8.jpg`
   - `xpeng-p7i.jpg`
   - `aion-y-plus.jpg`

---

## Option 3: Update RLS to Allow Uploads with Anon Key (Not Recommended)

If you want to use the anon key for uploads, you would need to modify the RLS policies to allow it, but this is **not secure** for production.

---

## Recommendation

**Option 1** is best if you can find the service role key.  
**Option 2** is safest if you can't find it - manual upload is secure and straightforward.

The service role key should be clearly visible under Settings > API in your Supabase dashboard, usually labeled as "service_role" or "Service Role (secret)".
