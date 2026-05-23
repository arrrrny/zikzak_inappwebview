# Research: Dismiss Dialogues Setting

## Decisions

### JavaScript injection approach

- **Decision**: Use Dart-side JavaScript evaluation (evaluateJs) to run overlay removal logic after page load
- **Rationale**: Consistent across all platforms — the existing `evaluateJs` method is already available in the web view controller and works on all platforms
- **Alternatives considered**: Native-side DOM traversal (platform-specific, harder to maintain)

### Overlay removal timing

- **Decision**: Trigger removal after page load completes (onLoadStop callback), with retries
- **Rationale**: Catches both initial overlays and dynamically injected ones; onLoadStop is already a hook point in the existing architecture
- **Alternatives considered**: Continuous DOM mutation observer (overhead, complexity)

### Retry strategy

- **Decision**: 3 retries with 800ms delay between retries
- **Rationale**: Balances reliability against performance; 3 retries catches most dynamic overlays while keeping total wait under 3 seconds
- **Alternatives considered**: Single attempt (misses late-loading overlays), unlimited retries (performance concern)

### Scope boundaries

- **Decision**: Only top-level document — iframes not modified
- **Rationale**: Cross-origin restrictions prevent iframe access; same-domain iframes could be added later if needed
- **Alternatives considered**: Recursive iframe traversal (complex, cross-origin security issues)

### Error handling

- **Decision**: Silent catch — errors during removal bubble up to a no-op handler, never crash the web view
- **Rationale**: Overlay removal is a cosmetic enhancement, not a critical path; failures should be invisible to the user
- **Alternatives considered**: Propagating errors (would break page rendering)
