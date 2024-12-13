# Sklik Server-Side Google Tag Manager Template

This document provides a comprehensive overview of the Sklik server-side Google Tag Manager (GTM) template, including its configuration options, logic flow, and how it processes conversion and retargeting events.

---

## Overview

The Sklik GTM server-side template facilitates the sending of conversion and retargeting events to Sklik (Seznam.cz's advertising platform). It uses server-side tagging to enhance data privacy, ensure reliable event tracking, and maintain compatibility with browser restrictions.

---

## Key Functions

- **`logToConsole`**: Logs messages to the server-side console for debugging purposes.
- **`getRequestHeader`**: Fetches HTTP request headers.
- **`getEventData`**: Retrieves data from incoming events.
- **`sendPixelFromBrowser`**: Sends a pixel request back to the browser to preserve third-party cookies and the client’s IP address.

---

## Template Inputs

### Conversion Inputs

- **`conversionId` (Required)**: ID of the conversion event.
- **`conversionValue` (Optional)**: Value associated with the conversion.
- **`conversionOrderId` (Optional)**: Unique order ID for the conversion.
- **`conversionZboziId` (Optional)**: ID for Zbozi.cz (disabled in current implementation).
- **`conversionZboziType` (Optional)**: Type for Zbozi.cz (disabled in current implementation).

### Retargeting Inputs

- **`retargetingId` (Required)**: ID for the retargeting event.
- **`retargetingItemId` (Optional)**: Item ID for the retargeting event.
- **`retargetingPageType` (Optional)**: Type of page for the retargeting event.
- **`retargetingCategory` (Optional)**: Category for the retargeting event.
- **`retargetingUrl` (Optional)**: URL for the retargeting event.

### Common Inputs

- **`tagType` (Required)**: Specifies whether the tag is for conversion or retargeting.
- **`tagConsent` (Required)**: Defines consent logic. Accepted values:
  - `inherit`: Consent is determined by the `x-ga-gcs` event data.
  - `granted`: Consent is explicitly granted.
  - `denied`: Consent is explicitly denied.

---

## Logic Flow

### 1. Initialization

- Logs the start of the template execution.
- Captures essential event data, including:
  - **`pageReferrer`**: Referring page URL.
  - **`consentState`**: Consent signal from the event data (`x-ga-gcs`).

### 2. Tag Type Handling

Depending on `tagType`, the script processes either a **conversion** or **retargeting** event:

#### Conversion

- Constructs the base URL: `https://c.seznam.cz/conv?id=...`
- Appends optional query parameters (e.g., `value`, `orderId`, etc.).

#### Retargeting

- Constructs the base URL: `https://c.seznam.cz/retargeting?id=...`
- Appends optional query parameters (e.g., `itemId`, `pageType`, etc.).

### 3. Consent Evaluation

- Evaluates the consent state based on `tagConsent`:
  - **`inherit`**: Uses the third character of `x-ga-gcs` to determine consent (`1 = granted`, `0 = denied`, `-1 = unknown`).
  - **`granted`** or **`denied`**: Sets explicit consent values.
- Appends the consent flag (`consent`) to the destination URL.

### 4. Send Pixel

- Logs the final destination URL.
- Sends a pixel request to the Seznam.cz server using `sendPixelFromBrowser`.

### 5. Completion

- Calls `data.gtmOnSuccess` to signal successful tag execution.

---

## Destination URL Construction

The final URL is constructed dynamically based on input values and the tag type. Example formats:

### Conversion:
```php
https://c.seznam.cz/conv?id=&value=&orderId=&url=&consent=
```

### Retargeting:
```php
https://c.seznam.cz/retargeting?id=&itemId=&pageType=&url=&consent=
```

---

## Error Handling

- If any required input (e.g., `conversionId` or `retargetingId`) is missing, the script will not execute correctly, and debugging logs will indicate the issue.
- Consent state is handled gracefully, with a default value of `-1` (unknown) if no valid consent signal is found.

---

## Debugging

- Use `logToConsole` messages to trace the script’s execution flow.
- Check the constructed URLs in the server logs for validation.
