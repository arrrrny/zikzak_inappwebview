# Feature Specification: Dismiss Dialogues Setting

**Feature Branch**: `002-dismiss-dialogues`

**Created**: 2026-05-23

**Status**: Draft

**Input**: User description: "Add a new setting to inAppWebviewsettings called dismissDialogues set true by default that will dismiss fixed/sticky overlays for clean captures"

## User Scenarios & Testing

### User Story 1 - Default overlay dismissal (Priority: P1)

A developer configures an in-app web view using the default settings. When the web view loads a page with popup dialogs, cookie banners, or chat widgets (fixed/sticky positioned elements), these overlays are automatically removed. The developer can capture a screenshot or PDF of the page content without obstructions.

**Why this priority**: Core functionality — the default behavior must work out-of-the-box so users consistently get clean captures without extra configuration.

**Independent Test**: Can be tested by loading any web page with fixed/sticky overlays using default settings and verifying the overlays are absent in the rendered content.

**Acceptance Scenarios**:

1. **Given** a web page containing fixed-position popup elements, **When** the page finishes loading in the web view, **Then** all fixed and sticky positioned elements are removed from the DOM.
2. **Given** a web page containing sticky-positioned navigation bars, **When** the page finishes loading in the web view, **Then** sticky elements are also removed.
3. **Given** the default configuration, **When** a web page loads, **Then** document and body overflow/margin styles are reset to prevent scrollbar artifacts.

---

### User Story 2 - Opt-out of overlay removal (Priority: P2)

A developer needs to preserve the original appearance of a web page including its overlays (e.g., sticky navigation, embedded chat widget). They explicitly disable the dismissDialogues setting. The web view renders the page without any automatic removal of fixed or sticky elements.

**Why this priority**: Provides flexibility for use cases where the original page layout must be preserved.

**Independent Test**: Can be tested by setting dismissDialogues to false and verifying that a page with overlays retains all fixed/sticky elements.

**Acceptance Scenarios**:

1. **Given** dismissDialogues is set to false, **When** a page with fixed overlays loads, **Then** all fixed and sticky elements remain visible and functional.
2. **Given** dismissDialogues is set to false, **When** the page content is captured as a screenshot or PDF, **Then** overlays appear in the captured output.

---

### User Story 3 - Dynamic late-loading overlays (Priority: P3)

A web page loads additional overlay content dynamically after the initial page load (e.g., delayed popup, cookie consent that appears after 2 seconds). The system retries overlay removal to catch these late-appearing elements, resulting in a clean page.

**Why this priority**: Handles real-world web patterns where overlays are not present at initial load, improving capture reliability.

**Independent Test**: Can be tested with a page that injects a fixed overlay after a delay, verifying it is still removed.

**Acceptance Scenarios**:

1. **Given** dismissDialogues is enabled, **When** a fixed overlay appears dynamically after initial page load, **Then** the overlay is removed within the retry window.
2. **Given** dismissDialogues is enabled and no overlays exist, **When** the page loads and removal attempts run, **Then** the process completes without errors or side effects.

---

### Edge Cases

- What happens when the loaded page contains no fixed or sticky elements? The removal logic runs without error and makes no changes.
- What happens if a JavaScript error occurs during overlay removal? The error is silently handled and does not break the web view or affect page rendering.
- What happens when the page uses fixed/sticky elements for essential functionality (e.g., sticky form validation)? Those elements are removed, which may affect page behavior — the developer can opt out by disabling the setting.
- What happens on pages with iframes that contain overlays? Only the top-level document's overlays are handled; iframe content is not modified.

## Requirements

### Functional Requirements

- **FR-001**: The system MUST provide a `dismissDialogues` configuration option in the web view settings.
- **FR-002**: The `dismissDialogues` option MUST default to enabled (true).
- **FR-003**: When enabled, the system MUST identify all HTML elements with CSS `position: fixed` or `position: sticky` on the loaded page.
- **FR-004**: When enabled, the system MUST remove all identified fixed/sticky elements from the page DOM.
- **FR-005**: When enabled, the system MUST reset the `overflow` and `margin` CSS properties on both `document.documentElement` and `document.body`.
- **FR-006**: When enabled, the system MUST retry overlay removal multiple times to catch dynamically loaded overlays, with a reasonable delay between retries.
- **FR-007**: When disabled (`false`), the system MUST NOT perform any automatic DOM modification related to overlay removal.
- **FR-008**: JavaScript errors during overlay removal MUST NOT propagate to or break the web view.
- **FR-009**: The overlay removal process MUST only affect the top-level document, not nested iframes or child frames.

### Key Entities

- **InAppWebViewSettings**: The configuration object that contains the `dismissDialogues` boolean setting and other web view configuration options.
- **dismissDialogues setting**: A boolean flag controlling whether fixed/sticky overlays are automatically removed from the loaded web page.

## Success Criteria

### Measurable Outcomes

- **SC-001**: A developer can enable or disable overlay removal by toggling a single configuration option.
- **SC-002**: With default settings, any web page containing fixed or sticky overlays renders without those elements — verified by inspecting the final DOM state.
- **SC-003**: Dynamically injected overlays that appear within the retry window are successfully removed.
- **SC-004**: When the setting is disabled, all fixed/sticky elements remain intact and functional after page load.
- **SC-005**: The overlay removal process never causes the web view to crash or display an error, regardless of page complexity or JavaScript errors.

## Assumptions

- The `dismissDialogues` setting is configured before the web view loads a page (not toggled dynamically mid-session).
- The overlay removal runs automatically when the page content is ready and the setting is enabled.
- Fixed/sticky positioned elements are assumed to be non-essential overlays (popups, banners, chat widgets). Elements using fixed/sticky for legitimate layout purposes (e.g., sticky headers) may also be removed — developers should disable the setting if they need to preserve these.
- Dynamic overlays are expected to appear within a few seconds of page load; the retry window covers this timeframe.
- Iframe-contained overlays are out of scope for automated removal, as cross-origin restrictions prevent modification.
