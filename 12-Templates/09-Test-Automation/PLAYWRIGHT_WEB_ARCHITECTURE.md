---
title: "PLAYWRIGHT_WEB_ARCHITECTURE"
description: "Blueprint for Playwright Web Architecture"
type: "template"
updated: "2026-07-31T13:31:41"
---

# Playwright Web Architecture + POM + Custom Fixtures + Accessibility (Axe-core)

Reference repository structure:

```
09-test-automation-architecture/examples/web-compliance-framework/
├── config/
│   └── env.config.ts
├── fixtures/
│   └── test.fixtures.ts
├── pages/
│   ├── base.page.ts
│   ├── heroku-alerts.page.ts
│   └── juice-shop.page.ts
└── tests/
    ├── accessibility.spec.ts
    └── native-alerts.spec.ts
```

File: `pages/base.page.ts`


```TypeScript
import { Page } from '@playwright/test';

export abstract class BasePage {
  readonly page: Page;

  constructor(page: Page) {
    this.page = page;
  }

  async navigateTo(path: string): Promise<void> {
    await this.page.goto(path);
  }
}
```

File: `pages/juice-shop.page.ts`


```TypeScript
import { Locator, Page } from '@playwright/test';
import { BasePage } from './base.page';

export class JuiceShopPage extends BasePage {
  readonly dismissBannerButton: Locator;

  constructor(page: Page) {
    super(page);
    this.dismissBannerButton = page.getByRole('button', { name: 'Dismiss' });
  }

  async dismissInitialBanners(): Promise<void> {
    if (await this.dismissBannerButton.isVisible()) {
      await this.dismissBannerButton.click();
    }
  }
}
```

File: `pages/heroku-alerts.page.ts`


```TypeScript
import { Locator, Page } from '@playwright/test';
import { BasePage } from './base.page';

export class HerokuAlertsPage extends BasePage {
  readonly jsAlertButton: Locator;
  readonly resultText: Locator;

  constructor(page: Page) {
    super(page);
    this.jsAlertButton = page.getByRole('button', { name: 'Click for JS Alert' });
    this.resultText = page.locator('[data-testid="result"], #result');
  }

  async triggerJsAlert(): Promise<void> {
    await this.jsAlertButton.click();
  }
}
```

File: `fixtures/test.fixtures.ts`


```TypeScript
import { test as base } from '@playwright/test';
import { JuiceShopPage } from '../pages/juice-shop.page';
import { HerokuAlertsPage } from '../pages/heroku-alerts.page';

type FrameworkFixtures = {
  juiceShopPage: JuiceShopPage;
  herokuAlertsPage: HerokuAlertsPage;
};

export const test = base.extend<FrameworkFixtures>({
  juiceShopPage: async ({ page }, use) => {
    const juiceShop = new JuiceShopPage(page);
    await use(juiceShop);
  },
  herokuAlertsPage: async ({ page }, use) => {
    const herokuAlerts = new HerokuAlertsPage(page);
    await use(herokuAlerts);
  },
});

export { expect } from '@playwright/test';
```

File: `tests/accessibility.spec.ts`


```TypeScript
import { test, expect } from '../fixtures/test.fixtures';
import AxeBuilder from '@axe-core/playwright';

test.describe('WCAG Accessibility Auditing Suite', () => {
  test('TC_AUTO_ACC_001 - WCAG 2.0/2.1 AA Compliance Audit on Landing Page', async ({ page, juiceShopPage }) => {
    await juiceShopPage.navigateTo(process.env.BASE_URL || 'https://preview.owasp-juice.shop/#/');
    await juiceShopPage.dismissInitialBanners();

    const accessibilityScanResults = await new AxeBuilder({ page })
      .withTags(['wcag2a', 'wcag21aa'])
      .exclude('#searchQuery') // Explicit exclusion of third-party components with known defects
      .analyze();

    const criticalViolations = accessibilityScanResults.violations.filter(
      (v) => v.impact === 'critical' || v.impact === 'serious'
    );

    expect(criticalViolations).toEqual([]);
  });
});
```

File: `tests/native-alerts.spec.ts`


```TypeScript
import { test, expect } from '../fixtures/test.fixtures';

test.describe('Native Browser Interactions Suite', () => {
  test('TC_AUTO_UI_001 - Interception and Validation of Native JS Alert Dialog', async ({ page, herokuAlertsPage }) => {
    await herokuAlertsPage.navigateTo(process.env.HEROKU_ALERTS_URL || 'https://the-internet.herokuapp.com/javascript_alerts');

    // Native event listener registration prior to activation
    page.once('dialog', async (dialog) => {
      expect(dialog.type()).toBe('alert');
      expect(dialog.message()).toBe('I am a JS Alert');
      await dialog.accept();
    });

    await herokuAlertsPage.triggerJsAlert();
    await expect(herokuAlertsPage.resultText).toHaveText('You successfully clicked an alert');
  });
});
```
