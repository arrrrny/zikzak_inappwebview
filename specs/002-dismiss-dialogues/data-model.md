# Data Model: Dismiss Dialogues Setting

## InAppWebViewSettings (existing entity — modified)

The `InAppWebViewSettings` class is a configuration object passed to the web view during initialization and optionally during runtime. This feature adds a single new property.

### New Property

| Field | Type | Default | Description |
|---|---|---|---|
| `dismissDialogues` | `bool` | `true` | When enabled, automatically removes all HTML elements with `position: fixed` or `position: sticky` from the loaded page. Resets `overflow` and `margin` styles on `html` and `body` elements. Retries up to 3 times with delay to catch dynamically loaded overlays. |

### Validation Rules

- No special validation — standard boolean coercion applies via platform channel.
- Setting to `false` means no automatic DOM modification occurs.

### State Transitions

- **Before page load**: Setting is read from configuration.
- **On page load complete** (when enabled): JavaScript is injected to find and remove all `fixed`/`sticky` elements, then reset page styles.
- **Retries**: If new overlays appear dynamically, up to 3 removal attempts run with ~800ms delay between each.
- **After page load** (when disabled): No action is taken.
