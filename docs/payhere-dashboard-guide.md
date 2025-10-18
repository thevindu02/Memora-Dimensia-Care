# PayHere Dashboard Navigation Guide

## Where to Find Your Credentials

### Step 1: Login to PayHere Sandbox
```
URL: https://sandbox.payhere.lk/
```

### Step 2: Navigate to Settings
```
Dashboard → Settings (left sidebar) → Domains & Credentials
```

### Step 3: Locate Your Credentials

You'll see a page with sections like this:

```
┌─────────────────────────────────────────────────┐
│  DOMAINS & CREDENTIALS                          │
├─────────────────────────────────────────────────┤
│                                                 │
│  Merchant ID                                    │
│  ┌─────────────┐                                │
│  │  1234567    │ ← Copy this (7-digit number)   │
│  └─────────────┘                                │
│                                                 │
│  Merchant Secret                                │
│  ┌────────────────────────────────────────────┐ │
│  │  MjM0NTY3ODkwMTIzNDU2Nzg5MDEyMzQ1Njc...  │ │
│  └────────────────────────────────────────────┘ │
│  ↑ Copy this entire string                     │
│                                                 │
│  Notify URL                                     │
│  ┌────────────────────────────────────────────┐ │
│  │  https://xxxx.ngrok-free.app/api/...      │ │
│  └────────────────────────────────────────────┘ │
│  ↑ Paste your webhook URL here                 │
│                                                 │
│  [ Save Changes ]                               │
│                                                 │
└─────────────────────────────────────────────────┘
```

### What to Copy

1. **Merchant ID**: The 7-digit number
   - Example: `1234567`
   - Paste into: `payhere_config.dart` → `sandboxMerchantId`

2. **Merchant Secret**: Long alphanumeric string
   - Example: `MjM0NTY3ODkwMTIzNDU2Nzg5MDEyMzQ1Njc4OTAxMjM0NTY3ODkw`
   - Paste into: `payhere_config.dart` → `sandboxMerchantSecret`

3. **Notify URL**: Your webhook endpoint
   - Example: `https://abc123.ngrok-free.app/api/payments/webhook/payhere`
   - Enter this in the PayHere dashboard (don't paste in code)

## Common Questions

### Q: I don't see "Domains & Credentials"
**A**: Make sure you're logged into the sandbox dashboard, not the main website. Look for "sandbox" in the URL.

### Q: My Merchant ID has letters in it
**A**: That's fine! Some merchant IDs may have letters. Just copy the entire value.

### Q: What if I don't have a Merchant Secret yet?
**A**: Some accounts may need to generate it. Look for a "Generate" or "Show Secret" button.

### Q: Where do I get the Notify URL?
**A**: This comes from YOUR backend. If using ngrok:
1. Run: `ngrok http 8080`
2. Copy the HTTPS URL
3. Add `/api/payments/webhook/payhere` to the end

### Q: Can I test without a Notify URL?
**A**: Yes, but you won't receive payment confirmations in your backend. The PayHere payment screen will still work.

## Visual Checklist

```
Setup Progress:
├─ [✓] Created PayHere sandbox account
├─ [✓] Found Settings → Domains & Credentials page
├─ [✓] Copied Merchant ID → payhere_config.dart
├─ [✓] Copied Merchant Secret → payhere_config.dart
├─ [✓] Started ngrok tunnel
├─ [✓] Added Notify URL to PayHere dashboard
├─ [✓] Saved changes in PayHere dashboard
└─ [✓] Updated payhere_config.dart with all values
```

## Screenshot Locations

When you open PayHere sandbox dashboard, you should see:

```
Top Navigation Bar:
[Dashboard] [Transactions] [Settings] [Reports] [Help]
                              ↑
                         Click here

Left Sidebar in Settings:
├─ Account Settings
├─ Business Info
├─ Domains & Credentials  ← Click here
├─ Bank Details
└─ API Keys
```

## Troubleshooting

### Can't find Settings
- Look at the top navigation bar
- Click your profile icon (top right)
- Select "Settings" from dropdown

### Dashboard looks different
- Make sure you're at `sandbox.payhere.lk` (not `www.payhere.lk`)
- Try logging out and back in
- Clear browser cache

### Credentials not showing
- Some accounts need approval first
- Check your email for verification links
- Contact PayHere support if needed

---

**Need Help?**
- PayHere Support: https://support.payhere.lk/
- Live Chat: Available in PayHere dashboard
- Email: sandbox@payhere.lk (for sandbox issues)
