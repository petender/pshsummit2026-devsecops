# DevSecOps A–Z: Demo Reference Guide

**Session duration:** 80 minutes (~2–3 min per letter; group thin letters)  
**Environment:** Personal GitHub account + GitHub Copilot + Azure  
**Audience:** Developers and engineers new to or deepening DevSecOps knowledge

---

## A — Alerts, Audit Logs, Autofix

**What it is:** GHAS generates security *alerts* (code scanning, secret scanning, Dependabot) visible in the Security tab. *Audit logs* capture every org-level action. *Autofix* uses Copilot to suggest a one-click code fix for detected vulnerabilities.


**Demo - Audit Logs:**
1. (If Org/Ent account) Navigate to **Org → Settings → Audit log** — filter by `action:repo` to show tamper-evident logging.
2. (If Personal account) Navigate to **Account → Archive → Security Logs** - show details + explanation + IP Source + date,... 

**Demo - Alerts & Autofix:**
1. Open the **Security** tab of the [GH-500-Dependabot-demo](https://github.com/petender/gh-500-dependabot-demo/security) with GHAS enabled — show the security * quality dashboard (code scanning + Dependabot alerts).
2. Click a code scanning alert (e.g., a SQL injection or XSS finding from CodeQL).
3. Click **"Generate fix"** — Copilot Autofix proposes a code change inline.
4. Accept the fix → it opens a PR automatically.


**Key message:** Alerts are the outputs; Autofix closes the loop between *finding* and *fixing* without leaving GitHub.

---

## B — Branch Protection Rules

**What it is:** Rules on a branch (typically `main`) that gate merges: require passing status checks, code reviews, signed commits, or no bypasses even for admins.

**Demo:**
1. Clone the repo to your local machine + open in VSCode
2. Create new branch for a certain feature
3. Make some code updates + commit change + sync
4. Switch to github repo and complete the PR steps + merge
5. Go to settings / tags → highlight it's deprecated but replaced with rulesets
6. Go to settings / branches / branch protection rules
7. Open rulesets / create new and highlight difference between branch or tag
8. Select new branch ruleset
9. Specify target branch as both default + include pattern = main
10. Set restrict updates
11. Make rule active
12. Switch back to VSCode + make update in the current branch + commit → successful
13. Switch to main branch + make another update + commit → fails
14. Open git log + emphasize the clear message showing you cannot update the protected branch



**Key message:** Branch protection is the enforcement mechanism that makes "shift-left" mandatory, not optional.

---

## C — Code Scanning & CodeQL

**What it is:** *Code scanning* is SAST (Static Application Security Testing) built into GitHub. *CodeQL* is the underlying query engine — it models code as a database and runs queries to find vulnerability classes (injection, path traversal, deserialization, etc.).

**Demo:**
#### Baseline Code Scanning
1. Open repo [petender/gh-500-codescanning-demo](https://github.com/petender/gh-500-codescanning-demo)
2. Navigate to **Security → Code scanning** — should show a few issues listed
3. Open an item and highlight how the code is being analyzed and exposes the potential security risk (e.g., cross-site-scripting)
4. Scroll down to show the remediation recommendation provided
5. Scroll further to show references from OWASP and Common Weakness Enumeration (CWE)

#### CodeQL Actions
1. From repo [petender/gh-500-codescanning-demo](https://github.com/petender/gh-500-codescanning-demo), select **Actions** → **CodeQL Advanced**.
2. Open **jobs** — show the 2 different analysis tasks (C# and JavaScript).
3. Open the **workflow file** to display the YAML code:
    - Highlight **line 69** — `Initialize CodeQL` step.
    - Highlight **line 98** — `Perform CodeQL analysis` step.
4. Open the **job log** and walk through the key steps:
    - Initialize CodeQL
    - Perform CodeQL analysis
5. Open **line 30** to show details about the .NET framework configuration.
6. Open **line 172** to show details about the running queries for C#.


#### CodeQL in VS Code
1. Assume CodeQL VS Code extension and CodeQL CLI are already installed.
2. Clone the [petender/gh-500-codeql-demo](https://github.com/petender/gh-500-codeql-demo) repo in VS Code and open the source code view.
3. Select the **CodeQL extension** from the sidebar.
4. Describe the setup of three key components:
    - **Languages:** Select which language to analyze (e.g., JavaScript, C#, Python).
    - **Databases:** Explain these are created using `codeql database create` from the command line. Click **Choose db from folder** → select the `\codeqldb` folder. This adds the database to your list.
    - **Queries:** Browse the `.ql` query files (e.g., `example.ql`), each targeting a specific vulnerability class like missing input validation or SQL injection.
5. Right-click a query (e.g., `example.ql` which scans for `PageModel` actions accessing `Logger` that go unused).
6. Select **Run from a local database** → wait for the task to complete.
7. Show results in the **Results panel** — demonstrate how CodeQL surfaces findings directly in the editor.

**Key message:** CodeQL doesn't just grep for patterns — it traces data flow, so it finds real vulnerabilities, not noise.

---

## D — Dependabot & Dependency Review

**What it is:** *Dependabot* monitors your dependency manifest for known CVEs and opens automated PRs to upgrade. *Dependency review* blocks a PR from merging if it introduces a new vulnerable dependency.

**Demo:**
#### Main Dependabot Capability - Enable
1. Open the sample repo [gh-500-dependabot-demo](https://github.com/petender/gh-500-dependabot-demo).
2. Navigate to the **Security** tab — show that Dependabot alerts are enabled.
3. Select **View Dependabot alerts**.
4. Open the first alert (e.g., Command injection in lodash).
5. Describe the severity details displayed on the right-hand side.
6. Scroll down from the severity details to locate the link to the GitHub Advisory Database.
7. Grab the CVE ID and open it from [cve.org](https://cve.org).

#### Dependabot – Dependency Graph
1. From the repo view, navigate to **Insights → Dependency graph**.
2. Explain how each package is listed with its own set of dependencies — show a package with multiple nested dependencies to illustrate the supply chain depth.
3. Switch to the **Dependabot** tab to access version updates.
4. Open **javascript/package.json** and select **"Recent update jobs"** to show completed and pending Dependabot PRs.
5. Click **Export SBOM** and download in SPDX JSON format.
6. Open the JSON file in VS Code, right-click, and select **Format Document** (or a JSON prettifier extension) to make it more readable.
7. Scroll through the formatted JSON and highlight:
    - Top-level `packages` array with name, version, and license for each dependency.
    - `externalReferences` section linking back to package repos and CVE databases.
    - `relationships` section showing which packages depend on which others.
8. Explain: this SBOM is the complete bill of materials — useful for audits, compliance reporting, and supply chain risk analysis.


#### Dependabot – GHAS Settings
1. Navigate to the repo **Settings → Code security and analysis → Advanced Security**.
2. Scroll to the **Dependabot** section and describe the available options:
    - **Dependabot alerts** — detects vulnerabilities in dependencies; toggle to enable.
    - **Dependabot security updates** — automatically opens PRs for known CVEs; toggle to enable.
    - **Dependabot version updates** — automatically opens PRs for available updates; toggle to enable.
    - **Grouped pull requests** — groups multiple updates into a single PR to reduce noise.
3. From the repo, navigate to **Actions → Dependabot Updates** (the scheduled workflow).
4. Open a successfully completed pipeline run.
5. From the workflow logs, expand and show:
    - **Updater** task — demonstrates the logic that scans dependency manifests, identifies outdated or vulnerable packages, and prepares the PR payload.
    - **Proxy** task — shows how Dependabot communicates back to GitHub via API backend calls (token exchange, PR creation, status updates).
6. Highlight the API calls in the logs to illustrate the secure handshake between the Dependabot service and the GitHub repository.


#### Dependabot – Actions YML
1. Open the dependabot.yml file from the repo code ./github folder, to show how it is currently defined as a regular actions workflow, using a scheduled weekly interval and checks both the javascript and ruby directories for packages


#### Dependabot-Dependency-Review
#### Dependabot – Dependency Review

1. From the dependabot-demo repo, navigate to **Actions → New workflow**.
2. Search the marketplace for "dependency review" and select the **Dependency Review** action — review the YAML to show it's a standard GitHub Actions workflow.
3. Close without saving.
4. Navigate to the already-existing **Dependency Review** workflow in the repo.
5. Open the latest run (e.g., "bump actions/checkout…") and click **Details** to view the OpenSSF Scorecard results — note the green/yellow scores.
6. From the repo code view, navigate to **/ruby/gemfile**.
7. Edit the file and add the following two lines:
    ```ruby
    gem 'nokogiri', '1.10.0' # This version has several known vulnerabilities.
    gem 'someweirdpackage', '1.0.0'
    ```
8. Save the changes in a new branch and open a PR (the current trigger for Dependency Review).
9. Navigate to **Actions → Dependency Review** and open the workflow run details — show that **1 vulnerability was detected + 1 unknown license**.
10. Scroll down to view detailed vulnerability information for the `nokogiri` package (known CVEs for version 1.10.0).


(nokogiri has known vulnerabilities and the someweirdpackage does not exist as an official ruby package, so should get triggered as vulnerability)

```cshapr
gem 'nokogiri', '1.10.0' # This version has several known vulnerabilities.

gem 'someweirdpackage', '1.0.0'
```

11. Save the changes in a new branch and PR, since that is the current trigger for the Ruby – Run Bundler action or the Dependency Review action, which both have the dependency review task.
12.	Navigate to Actions, Dependency Review; open the details, which will show that 1 vulnerability got detected + 1 unknown license
13.	Scroll down shows more details for the nokogiri package vulnerabilities


**Key message:** Dependabot tells you what's broken; Dependency review stops you from making it worse in the first place.

---

## E — Environment Protection Rules

**What it is:** GitHub Actions *environments* (e.g., `production`) can have protection rules: required reviewers, wait timers, and branch filters. This gates the *deployment* step even if CI passes.

**Demo:**

#### Setup — configure the environments
1. Navigate to repo [petender/pshsummit2026-devsecops](https://github.com/petender/pshsummit2026-devsecops) → **Settings → Environments → New environment** → name it `staging` → save (no protection rules needed).
2. Create a second environment named `production`.
3. Under `production`, enable **Required reviewers** → add yourself → save.
4. Still under `production`, expand **Deployment branches and tags** → select **Selected branches** → add rule `main` → save.
5. Open `.github/workflows/environment-protection-demo.yml` and walk through the three jobs:
   - **build** — simulates a build + test step
   - **deploy-staging** — targets the `staging` environment (no gate)
   - **deploy-production** — targets the `production` environment (gated)
6. Push a commit to `main` (or trigger via **Actions → Run workflow** from `main`).
7. Watch the **build** → **deploy-staging** jobs complete automatically.
8. The **deploy-production** job pauses — show the yellow "Waiting for review" state in the Actions UI.
9. Point out the approval notification email that arrives.
10. Click **Review deployments** → select `production` → **Approve and deploy** → show the job resume and the `echo` output confirming deployment.

**Key message:** Environments are the security gate between "tests passed" and "code is live in production."

---

## F — Fork Protection & FIPS

**What it is:** *Fork protection* ensures that secrets and environment tokens are **not** automatically available to workflows triggered from forks (pull_request_target risk). *FIPS* compliance mode enables FIPS 140-2 validated crypto in GitHub-hosted runners.

**Demo (Fork protection):**

> **PRE_REQ — how to trigger this demo:**  
> Workflows only fire when a **different GitHub account** forks the repo and opens a PR back to `main`. Just forking does nothing on its own — it's the inbound PR that fires the `pull_request` / `pull_request_target` events against *your* repo.  
> Use a second GitHub account (or ask a colleague): open a private browser window, log in as the second account, fork `petender/pshsummit2026-devsecops`, make a trivial change (e.g., add a blank line to the README), and open a PR targeting `main`. Switch back to your primary account to watch the workflows fire.  
> **Important:** A PR from your *own* branch (same account, same repo) will not demonstrate the sandbox — GitHub treats same-owner PRs as trusted and *does* inject secrets. The isolation only applies to PRs from a different owner's fork.  
> **Secret setup (do this before the session):** Go to **Settings → Secrets and variables → Actions → New repository secret**, name it `MY_DEMO_SECRET`, and set a clearly fake but recognisable value such as `s3cr3t-demo-value-DO-NOT-USE`. The unsafe workflow will print this value in the Actions log — making the exposure unmistakably visible to the audience.

#### Step 1 — live demo of the unsafe pattern
1. Open `.github/workflows/fork-protection-unsafe.yml` in VS Code and walk through it:
   - `pull_request_target` trigger — runs in the context of the **base repo**, with repo secrets and write-scoped `GITHUB_TOKEN`
   - `actions/checkout` referencing `github.event.pull_request.head.sha` — checks out the **fork's code** while elevated token is in scope
   - The final step injects `MY_DEMO_SECRET` as an env var and prints it in the log
2. Have the second account open a fork PR (see pre-req) → switch back to your primary account.
3. In **Actions**, watch both workflows queue — open the unsafe run → expand **"Show that secrets are accessible here"** → the audience sees `MY_SECRET value: s3cr3t-demo-value-DO-NOT-USE` printed in plain text in the log.
4. Let that sink in: **a contributor who never had repo access just caused your secret to appear in a public Actions log.**

#### Step 2 — trigger the safe pattern with the second account
5. From the second GitHub account, open a PR from the fork to `main` (as described in the pre-req above).
6. Switch back to your primary account — in **Actions**, you'll see the **"Fork Protection Demo (safe pattern)"** workflow queued.
7. If fork approval is enabled, you'll see a **"Waiting for approval"** banner first — approve it, then watch the run.
8. Open the completed run and expand the **"Demonstrate no secret access from fork"** step — it outputs `✅ MY_SECRET is empty`, confirming secrets are withheld from fork-triggered builds.
9. Open `.github/workflows/fork-protection-safe.yml` side-by-side and point out:
   - `pull_request` trigger (not `pull_request_target`)
   - `permissions: contents: read` — explicitly least-privilege

#### Step 3 — fork approval settings in the UI
10. Navigate to **Settings → Actions → Fork pull request workflows**.
11. Walk through the three approval options:
    - *Require approval for first-time contributors* (default)
    - *First-time contributors from forks with no prior merged commits*
    - *All outside collaborators* (most conservative)
12. Show the "Waiting for approval" banner that appears in the Actions UI before a fork job runs when approval is required.

**Key message:** Forked PRs are an untrusted code path — treat them like external input, not internal code.

---

## G — GHAS, GitHub Actions, GPG Signing

**What it is:** *GHAS* (GitHub Advanced Security) is the umbrella for code scanning, secret scanning, and Dependabot advanced features. *GitHub Actions* is the CI/CD backbone. *GPG signing* provides cryptographic proof of commit authorship.

**Demo (GPG Signing):**

> **PRE-REQ — set up GPG signing (do this before the session):**
> GPG is bundled with Git for Windows at `C:\Program Files\Git\usr\bin\gpg.exe`. Add that folder to your user PATH if needed:
> ```powershell
> [Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\Program Files\Git\usr\bin", "User")
> ```
> Then close and reopen your terminal so `gpg` resolves without a full path.
>
> 1. Generate a key: `gpg --full-generate-key` → choose RSA 4096, no expiry, use your GitHub-verified email address.
> 2. List keys to grab the ID: `gpg --list-secret-keys --keyid-format LONG` → copy the 16-char hex ID after `rsa4096/`.
> 3. Export the public key: `gpg --armor --export <KEY_ID>` → copy the full output including the `-----BEGIN PGP PUBLIC KEY BLOCK-----` header/footer.
> 4. Add it to GitHub: navigate to **GitHub → Settings → SSH and GPG keys → New GPG key** → paste → save.
> 5. Configure git to use the key **for this repo only** (so other repos are unaffected):
>    ```powershell
>    git config --local user.signingkey <KEY_ID>
>    git config --local commit.gpgsign true
>    ```

#### Beat 1 — signed vs unsigned commit in the GitHub UI
1. Make a trivial change (e.g., add a blank line to `README.md`) → commit and push:
   ```powershell
   git add README.md
   git commit -m "demo: signed commit"
   git push
   ```
2. In the GitHub repo, navigate to **Code → Commits**.
3. Show the **Verified** green badge next to the new commit — click it to display the GPG key fingerprint GitHub used to verify.
4. Point to an earlier, unsigned commit in the history — it shows no badge. Side-by-side, the difference is unmistakable.

#### Beat 2 — cryptographic proof in the terminal
5. Run: `git log --show-signature -2`
6. Walk through the output:
   - `gpg: Good signature from "<Your Name> <email>"` — cryptographic proof the commit was made by the holder of this private key.
   - `Primary key fingerprint:` — the fingerprint ties back to the public key registered on GitHub.
   - An unsigned commit immediately above it will show `gpg: Can't check signature: No public key` or simply no GPG line at all.

#### Beat 3 — branch protection rejects unsigned commits
7. In the GitHub repo, navigate to **Settings → Branches → Edit** (or open the existing ruleset) → enable **Require signed commits** → save.
8. Back in the terminal, make a new change and commit **without** signing:
   ```powershell
   git commit --no-gpg-sign -m "demo: unsigned commit attempt"
   git push
   ```
9. Show the push rejection:
   ```
   remote: error: GH006: Protected branch update failed for refs/heads/main.
   remote: error: Commits must have verified signatures.
   ```
10. Re-commit with signing to restore: `git commit --amend --gpg-sign` → `git push --force-with-lease`.
11. After the demo, clean up the local signing config: `git config --local --unset commit.gpgsign`

**Key message:** A "Verified" badge means the commit cryptographically came from that identity — important for supply chain provenance.

---

## H — Hardened Runners & Hardening

**What it is:** *Hardening* is the practice of reducing attack surface on your workflows and runners. True runner-level egress filtering requires third-party tooling, but the most impactful hardening practices — token scoping, action pinning, and workflow change control — are built directly into GitHub.

**Demo file:** [`.github/workflows/hardening-demo.yml`](.github/workflows/hardening-demo.yml)

**Demo:**

#### Beat 1 — Minimal workflow permissions
1. Open `.github/workflows/hardening-demo.yml` and point to the top-level `permissions: read-all` block.
2. Explain that without an explicit `permissions:` block, GitHub grants `contents: write`, `packages: write`, and more by default — a compromised step could push code, create releases, or publish packages.
3. Show the `build` job — it declares `permissions: contents: read` only. Walk through the **"Show effective token permissions"** step output in the Actions run log.
4. Open the `release-attempt` job — it also has only `contents: read`. Run the workflow via **Actions → Run workflow** and watch the **"Attempt to create a release tag"** step fail with a 403. Point out this is a *deliberate* failure that proves the scoping is real.

#### Beat 2 — Pin actions to commit SHAs instead of mutable tags
5. In the workflow file, point to any `uses:` line — e.g.:
   ```
   uses: actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683  # v4.2.2
   ```
6. Explain the risk of mutable tags: an attacker who compromises the `actions/checkout` repo could push a backdoored commit to the `v4` tag — every workflow using that tag silently executes it on the next run.
7. Open the `sha-pinning-summary` job in the Actions run log — it prints a side-by-side comparison of the mutable tag vs pinned SHA with the explanation.

#### Beat 3 — Protect workflow files with CODEOWNERS
8. Open (or create) `.github/CODEOWNERS` — show the entry:
   ```
   .github/workflows/   @petender
   ```
9. In the branch protection ruleset, confirm **Require review from Code Owners** is enabled.
10. Have the second GitHub account (used in the fork demo) open a PR that modifies any workflow file.
11. Show the PR — the merge button is blocked with **"Review required from code owner"** even if all other checks pass.
12. Point out: this prevents a contributor from sneaking in a workflow change that exfiltrates secrets, because the repo owner *must* explicitly approve it.

**Key message:** Hardening doesn't require a third-party agent — scoping tokens, pinning SHAs, and gating workflow changes are native GitHub controls that eliminate entire attack classes.

---

## I — IaC Scanning

**What it is:** Infrastructure-as-Code scanning analyzes Bicep, ARM, or Terraform files for misconfigurations *before* deployment (e.g., open storage accounts, no HTTPS, overprivileged IAM roles).

> **Tooling note:** This demo uses `microsoft/security-devops-action`, a GitHub Action published and maintained by Microsoft. For Bicep and ARM templates it uses **Template Analyzer** — a Microsoft-built open-source tool. No third-party vendors (Checkov, KICS, etc.) are involved. Results are reported as SARIF and surface directly in GHAS Code Scanning.

**Demo files:**
- [`.github/workflows/iac-scanning.yml`](.github/workflows/iac-scanning.yml) — the scanning workflow
- [`infra/storage.bicep`](infra/storage.bicep) — the misconfigured Bicep file

**Demo:**

#### Beat 1 — Introduce the misconfigured Bicep file
1. Open `infra/storage.bicep` — point out the three deliberate misconfigurations marked in the comments: `publicNetworkAccess: 'Enabled'`, `allowBlobPublicAccess: true`, and `minimumTlsVersion: 'TLS1_0'`.
2. Push the file to a feature branch to trigger the workflow.

#### Beat 2 — Walk through the workflow
3. Open `.github/workflows/iac-scanning.yml` — highlight:
   - `paths: infra/**` trigger — only fires when IaC files change
   - `permissions: security-events: write` — required to upload SARIF
   - `microsoft/security-devops-action` with `categories: IaC` — runs Template Analyzer
   - `github/codeql-action/upload-sarif` — pushes results into GHAS Code Scanning
4. Navigate to **Actions** and watch the scan run complete.

#### Beat 3 — Review findings in GHAS Code Scanning
5. Go to **Security → Code scanning alerts** — show three findings from Template Analyzer:
   - *Storage account allows public blob access* (High)
   - *Storage account allows public network access* (Medium)
   - *Storage account minimum TLS version is below 1.2* (Medium)
6. Open one alert — show the file path, line number, rule description, and remediation guidance.
7. Point out these are real GHAS alerts: assignable, dismissable, tracked over time — identical UX to CodeQL findings.

#### Beat 4 — Fix and resolve
8. In `infra/storage.bicep`, update the three flagged properties to their safe values (comments in the file show exactly what to change).
9. Push → scan reruns → all three alerts close automatically.

**Key message:** Security misconfigurations in IaC are bugs too — and Microsoft's own tooling, integrated directly into GHAS, catches them in PR before anything is ever deployed.

---

## J — JWT & Keyless Auth (bridge to OIDC)

**What it is:** JSON Web Tokens are the credential format used in GitHub Actions' OIDC federation. When a workflow requests an Azure token, GitHub mints a short-lived JWT that Azure validates — no stored secret ever exists.

**Demo:** *(Best delivered as a visual before the OIDC demo — see letter O)*
1. Add a step to a workflow: `actions/github-script` to call `getIDToken()` and print the JWT (header + claims only — redact signature).
2. Paste the token into [jwt.io](https://jwt.io) — show the claims: `repository`, `ref`, `workflow`, `environment`, `sub`.
3. Explain: Azure checks these claims against the federated credential configuration. No password, no PAT.

**Key message:** A JWT is a signed, time-limited identity assertion — OIDC turns your workflow *identity* into a credential.

---

## K — Keyless Authentication & Key Rotation

**What it is:** *Keyless auth* (via OIDC) eliminates long-lived credentials. *Key rotation* is the fallback practice for secrets that can't be eliminated — rotate them automatically rather than manually.

**Demo (Key rotation via Dependabot secrets):**
1. Show an Azure service principal secret stored as a GitHub Actions secret.
2. Show a workflow that, on schedule, calls the Azure CLI to rotate the secret and uses the GitHub API to update the Actions secret — a self-healing rotation loop.
3. Compare: OIDC (no secret at all) vs rotated secret (still a secret, just fresher) — frame rotation as mitigation, OIDC as elimination.

**Key message:** The goal is zero long-lived secrets; rotation is the safety net while you get there.

---

## L — License Compliance & Least Privilege

**What it is:** *License compliance* — Dependency review can flag dependencies whose licenses are incompatible with your project (e.g., GPL in a proprietary product). *Least privilege* applies to tokens, service principals, and workflow permissions.

**Demo (Least Privilege in Actions):**
1. Show a workflow **without** an explicit `permissions:` block — GitHub grants `contents: write` and more by default (older default).
2. Add `permissions: contents: read` at the top level, then override per job.
3. Show a job that only needs to read code and post a comment — grant only `pull-requests: write, contents: read`.
4. Attempt to have a step create a release (needs `contents: write`) — it fails with a 403. Intentional.

**Key message:** `GITHUB_TOKEN` is a credential — scope it like one.

---

## M — MFA / 2FA & Merge Protection

**What it is:** Org-enforced *MFA* ensures no member can access org resources without a second factor. *Merge protection* via rulesets allows org-wide, cross-repo enforcement of merge conditions.

**Demo:**
1. Go to **Org → Settings → Authentication security → Require two-factor authentication** — show the toggle and what happens to non-compliant members (they get removed from the org).
2. Show **Org → Settings → Rulesets** (the newer, more powerful replacement for branch protection). Create a rule that applies to all repos matching `*`, requiring a passing code scan and one review.
3. Show a repo that has no branch protection set — yet the ruleset still applies.

**Key message:** Rulesets scale security policy from one repo to the entire organization in a single click.

---

## N — NIST SSDF & npm/NuGet Audit

**What it is:** *NIST SP 800-218* (Secure Software Development Framework) maps directly to what GHAS provides. *npm audit / NuGet audit* are the package-manager-native equivalents of Dependabot for local dev.

**Demo:**
1. Run `npm audit` in the terminal on a project with known-vulnerable packages — show the CVE list and `npm audit fix`.
2. Then show *Dependabot* covering the same CVEs automatically in GitHub, without requiring a developer to remember to run the audit command.
3. Map a NIST SSDF practice (e.g., PW.7 "Review and/or Analyze Human-Readable Code") to code scanning in the workflow.

**Key message:** GHAS automates what NIST tells you to do manually — it's compliance-as-code.

---

## O — OIDC (OpenID Connect)

**What it is:** OIDC federation lets GitHub Actions authenticate to Azure (or AWS, GCP) using a workflow's *identity* rather than a stored secret. Azure trusts GitHub's identity provider and issues a short-lived access token.

**Demo:**
1. In Azure: **App Registrations → Federated credentials** — add a credential for the GitHub repo + branch (`repo:myorg/myrepo:ref:refs/heads/main`).
2. In the GitHub workflow:
   ```yaml
   permissions:
     id-token: write
     contents: read
   steps:
     - uses: azure/login@v2
       with:
         client-id: ${{ vars.AZURE_CLIENT_ID }}
         tenant-id: ${{ vars.AZURE_TENANT_ID }}
         subscription-id: ${{ vars.AZURE_SUBSCRIPTION_ID }}
   ```
3. Run the workflow — show it authenticating to Azure with **no secret in the repo**.
4. Show **Org → Secrets** — there is no `AZURE_CLIENT_SECRET` stored anywhere.

**Key message:** If there's no secret to steal, there's no secret to rotate, leak, or phish. OIDC is the single biggest quick-win in DevSecOps.

---

## P — Push Protection & Policy as Code

**What it is:** *Push protection* intercepts a `git push` before it lands in the repo if GHAS detects a secret pattern (API key, connection string, PAT, etc.) in the diff. *Policy as Code* defines security gates in version-controlled files rather than point-and-click UI.

**Demo (Push Protection):**
1. Enable **Secret scanning → Push protection** on the repo.
2. In a local clone, add a file containing a fake (but real-pattern) secret: e.g., an Azure SAS token or a GitHub PAT-shaped string.
3. Run `git push` — show the **push rejected** message in the terminal with the secret type identified and a bypass URL.
4. Show the alert in the GitHub Security tab even if bypass was attempted.

**Key message:** Push protection is the last line of defense before a secret hits git history — which is nearly permanent.

---

## Q — Quality Gates

**What it is:** Quality gates are required status checks that must pass before a PR can merge. In a security context: code scanning must pass, dependency review must pass, and all security checks must be green.

**Demo:**
1. In branch protection (or a ruleset), add the code scanning workflow as a required status check.
2. Open a PR that introduces a `High` severity CodeQL finding.
3. Show the PR — the merge button is greyed out, the required check shows ✗ with the alert count.
4. Fix the vulnerability → push → check goes green → merge is unblocked.

**Key message:** Quality gates make security non-negotiable — developers can't ship around it.

---

## R — RBAC, Repository Rulesets & Risk Scoring

**What it is:** *RBAC* controls who can do what across your org (read/triage/write/maintain/admin). *Repository rulesets* enforce merge conditions org-wide. *Risk scoring* (via GHAS Security Overview) aggregates exposure across all repos.

**Demo (Security Overview / Risk Scoring):**
1. Navigate to **Org → Security → Overview**.
2. Show the **enablement status** view — which repos have code scanning, secret scanning, Dependabot enabled vs not.
3. Show the **Alerts** view — filter by severity, sort by repo to identify the riskiest repos.
4. Show **Coverage** percentage — this becomes your security KPI for the org.

**Key message:** Security Overview turns individual alerts into organizational risk — it answers "how secure is our *portfolio*?"

---

## S — Secret Scanning, SAST, SCA, SBOM, Shift-Left

**What it is:** The densest letter.  
- **Secret scanning:** Detects committed secrets (tokens, keys, passwords)  
- **SAST:** Static analysis for code vulnerabilities (CodeQL)  
- **SCA:** Software Composition Analysis — vulnerability in open-source dependencies (Dependabot)  
- **SBOM:** Software Bill of Materials — inventory of all components  
- **Shift-left:** Moving security earlier in the development lifecycle

**Demo (SBOM export):**
1. Go to a repo → **Insights → Dependency graph**.
2. Click **Export SBOM** — download in SPDX format.
3. Open the JSON file — show every dependency, version, and license.
4. Explain: this is what a customer, auditor, or government might require under emerging software supply chain regulations (e.g., US EO 14028, EU CRA).

**Key message:** An SBOM is a receipt for your software — GHAS generates it automatically from what's already tracked.

---

## T — Token Scoping, Threat Modeling & 2FA

**What it is:** *Token scoping* (`permissions:` in Actions) follows least privilege. *Threat modeling* is the practice of systematically identifying what could go wrong. *2FA* is org-enforced multi-factor (covered in M — quick reference).

**Demo (Threat Modeling with GitHub Copilot):**
1. Open GitHub Copilot Chat in VS Code.
2. Paste a workflow YAML and ask: *"Act as a security engineer. What are the security risks in this GitHub Actions workflow?"*
3. Copilot identifies: missing `permissions:`, use of `pull_request_target` with checkout, unpinned action SHA, secret printed in logs.
4. Apply fixes — each one maps to a real attack vector.

**Key message:** Copilot doesn't replace threat modeling — it accelerates it. Use it as a first-pass reviewer for your pipelines.

---

## U — Update Automation & Upstream Security

**What it is:** *Dependabot version updates* (vs security updates) keep dependencies current proactively — not just patching CVEs but staying close to upstream releases. *Upstream security* is the supply chain risk from compromised packages.

**Demo:**
1. Show a `dependabot.yml` config:
   ```yaml
   version: 2
   updates:
     - package-ecosystem: "npm"
       directory: "/"
       schedule:
         interval: "weekly"
       groups:
         dev-dependencies:
           patterns: ["*"]
   ```
2. Show the resulting grouped PRs → one PR per group rather than dozens of noise PRs.
3. Show **Dependabot security updates** vs **version updates** in settings — explain the difference (reactive vs proactive).

**Key message:** Staying current is security strategy — the further behind you fall, the harder (and riskier) upgrades become.

---

## V — Vulnerability Management & VEX

**What it is:** *Vulnerability management* is the lifecycle of triage, prioritize, fix, and verify. GHAS supports dismissal with reason (won't fix, false positive, used in tests). *VEX* (Vulnerability Exploitability eXchange) is an emerging standard for communicating whether a CVE in your SBOM is actually exploitable in your context.

**Demo:**
1. Open a Dependabot alert for a transitive dependency.
2. Show the options: **Review security advisory**, **See affected repositories**, **Dismiss** (with mandatory reason: "Vulnerable code not called" / "No bandwidth to fix" / "Tolerable risk").
3. Show the audit trail — dismissal is logged with who dismissed it and why.
4. Filter Security Overview to show dismissed vs open alerts — demonstrate risk acceptance is documented, not silent.

**Key message:** Dismissal isn't ignoring a vulnerability — it's documenting a risk decision. That audit trail is compliance gold.

---

## W — Workflow Security, Webhooks

**What it is:** *Workflow security* covers pinning action versions to full SHA (not floating tags), scoping `GITHUB_TOKEN` permissions, avoiding `pull_request_target` pitfalls. *Webhooks* can stream security events to SIEM (Splunk, Sentinel).

**Demo (Action pinning):**
1. Show a workflow using `actions/checkout@v4` (floating tag — could be hijacked if the tag is moved).
2. Compare with `actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683` — a pinned SHA.
3. Use the [StepSecurity Action Advisor](https://app.stepsecurity.io) to auto-pin all actions in a workflow in one click.
4. (Bonus) Show **Org → Settings → Webhooks** — add a webhook pointing at an Azure Logic App or a RequestBin to receive `security_advisory` events in real time.

**Key message:** `@v4` is a mutable pointer — a pinned SHA is an immutable, auditable reference.

---

## X — XSS & Injection Detection via CodeQL

**What it is:** CodeQL ships with built-in query suites that detect vulnerability classes including Cross-Site Scripting (XSS), SQL injection, path traversal, and command injection through data-flow analysis.

**Demo:**
1. In a Node.js/Express app, introduce: `res.send(req.query.name)` — reflected XSS.
2. Push to a branch — CodeQL flags it with the data-flow path from `req.query.name` (source) to `res.send` (sink).
3. Show the fix suggestion (Autofix or manual) — HTML-encode the output.
4. Show the same for a Python/Django SQL injection if time permits.

**Key message:** CodeQL finds the class of vulnerability, not just the instance — fix it once, and the query will catch regressions forever.

---

## Y — YAML Workflow Permissions

**What it is:** The `permissions:` key in a workflow YAML explicitly grants the `GITHUB_TOKEN` only the scopes it needs. Without it, workflows may implicitly have write access to contents, packages, deployments, and more.

**Demo:**
1. Show GitHub's [default token permissions table](https://docs.github.com/actions/security-guides/automatic-token-authentication#permissions-for-the-github_token).
2. Show a workflow with no `permissions:` block — run a third-party action and examine what the token *could* do.
3. Add `permissions: read-all` as a top-level default, then add `contents: write` only to the specific job that needs it.
4. Show org-level setting: **Org → Settings → Actions → Workflow permissions** — set default to "Read repository contents" so new repos are secure by default.

**Key message:** One line — `permissions: read-all` — is the highest-ROI security improvement you can make to most existing workflows today.

---

## Z — Zero Trust

**What it is:** Zero trust means *never trust, always verify* — no implicit trust based on network location, internal service, or previous authentication. In DevSecOps: every pipeline step authenticates explicitly, every action is logged, and access is continuously verified.

**Demo:**
1. Show the **full security picture** assembled through the session:
   - Signed commits (**G**)
   - OIDC — no stored secrets (**O**)
   - Scoped `GITHUB_TOKEN` (**Y**)
   - Environment gates before production (**E**)
   - Audit logs for every action (**A**)
   - Required security checks before merge (**Q**)
2. Overlay the Zero Trust principles:
   - *Verify explicitly* → CodeQL + secret scanning
   - *Use least privilege* → token scoping + RBAC
   - *Assume breach* → audit logs + push protection

**Key message:** Zero trust isn't a product — it's what you've been building all session. Every letter adds a layer.

---

## Quick-Reference Timing Guide

| Block | Letters | Suggested time |
|-------|---------|---------------|
| Intro + A–C | A, B, C | 12 min |
| Supply chain | D, U, S (partial) | 10 min |
| Pipeline security | E, F, G, H | 10 min |
| Keyless auth deep-dive | J, K, O | 12 min |
| Org-scale governance | L, M, N, R | 10 min |
| Shift-left scanning | P, Q, S, X | 10 min |
| Advanced + wrap-up | T, V, W, Y, Z | 10 min |
| Buffer / Q&A | — | 6 min |
| **Total** | | **~80 min** |

---

## Resources

- [GitHub Advanced Security documentation](https://docs.github.com/en/get-started/learning-about-github/about-github-advanced-security)
- [CodeQL query suites](https://docs.github.com/en/code-security/code-scanning/managing-your-code-scanning-configuration/built-in-codeql-query-suites)
- [Dependabot configuration reference](https://docs.github.com/en/code-security/dependabot/dependabot-version-updates/configuration-options-for-the-dependabot.yml-file)
- [GitHub Actions security hardening](https://docs.github.com/en/actions/security-for-github-actions/security-guides/security-hardening-for-github-actions)
- [OIDC federation with Azure](https://docs.github.com/en/actions/security-for-github-actions/security-hardening-your-deployments/configuring-openid-connect-in-azure)
- [StepSecurity Harden-Runner](https://app.stepsecurity.io)
- [NIST SSDF (SP 800-218)](https://csrc.nist.gov/Projects/ssdf)
- [SPDX SBOM standard](https://spdx.dev/)
