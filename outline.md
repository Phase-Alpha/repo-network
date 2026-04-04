# Reponet.work Development Outline

A federated code hosting platform for Jujutsu (JJ) VCS built with Elixir/Phoenix.

---

## Phase 1: Project Foundation (Start Here)

### 1.1 Initialize Phoenix Project
```bash
# Create new Phoenix app
mix phx.new reponet --database postgres
cd reponet
```

**Tasks for Claude Code:**
- Set up basic Phoenix project structure
- Configure PostgreSQL database
- Set up Docker and docker-compose.yml with:
  - Phoenix app container
  - PostgreSQL container
  - Redis container (for background jobs)
  - Cloudflared tunnel container
- Create .env file structure for secrets
- Set up basic authentication (phx.gen.auth)

### 1.2 Development Environment
**Tasks for Claude Code:**
- Create Dockerfile with multi-stage build
- Configure docker-compose for local development
- Set up hot-reloading in Docker
- Add healthcheck endpoints
- Create initial database migrations

### 1.3 GitHub OAuth Authentication
**Tasks for Claude Code:**
- Add Ueberauth and Ueberauth GitHub dependencies
- Create GitHub OAuth app in GitHub Developer Settings
- Configure OAuth credentials in environment variables
- Add OAuth routes (`/auth/github`, `/auth/github/callback`)
- Create AuthController to handle OAuth callback
- Implement find_or_create_user logic for GitHub users
- Store GitHub user data (username, email, avatar_url, github_id)
- Add "Sign in with GitHub" button to login page
- Test OAuth flow end-to-end

**Benefits:**
- Lower friction for developers already on GitHub
- Pre-populated user profiles
- Familiar authentication UX
- Potential to import SSH keys later

---

## Phase 2: Core JJ Integration

### 2.1 Research & Experimentation
**Tasks for Claude Code:**
- Create a `/research` directory with test scripts
- Write Elixir module to shell out to `jj` CLI commands
- Test basic operations: `jj init`, `jj log`, `jj show`
- Document JJ's output formats (JSON if available, otherwise parse text)
- Create proof-of-concept: store a JJ repo, read its log
- Understand JJ's bookmark/branch model vs Git branches

### 2.2 Repository Storage Module
**Tasks for Claude Code:**
- Design database schema for:
  - Repositories (name, owner, created_at, storage_path, default_bookmark)
  - Users (email, username, auth credentials, github_id, avatar_url)
  - Changes/Commits (leverage JJ's change IDs)
  - Bookmarks (JJ's equivalent of branches)
- Create Ecto schemas and migrations
- Build `Reponet.JJ` module with functions:
  - `create_repository/1`
  - `get_log/1`
  - `get_change/2`
  - `diff/2`
  - `list_bookmarks/1`
  - `create_bookmark/2`

### 2.3 File System Management
**Tasks for Claude Code:**
- Create `/repos` directory structure
- Implement repository initialization on disk
- Handle Git backend initialization for JJ repos
- Set up file permissions and ownership
- Create cleanup/garbage collection strategy

---

## Phase 3: Web Interface (MVP)

### 3.1 Basic Repository Browsing
**Tasks for Claude Code:**
- Create LiveView for repository list
- Create LiveView for single repository view
- Display commit/change log
- Show file browser for a given change
- Implement syntax-highlighted diff viewer
- Display bookmarks/branches list

### 3.2 User Authentication & Authorization
**Tasks for Claude Code:**
- Integrate phx.gen.auth (for local accounts)
- Ensure GitHub OAuth integrates with existing auth system
- Add repository ownership model
- Implement permissions (public/private repos)
- Create user profile pages (show GitHub avatar if available)
- Add collaborator management (for PR workflow)

### 3.3 Repository Creation UI
**Tasks for Claude Code:**
- Form to create new repository
- Initialize JJ repo on submission
- Set up initial README or empty repo
- Handle repository naming/validation
- Set default bookmark (usually `main`)

---

## Phase 4: Pull Requests / Change Requests

**Why this is critical:**
- Core workflow for collaboration
- Most developers won't push directly to main
- Essential even for solo projects (review before merge)
- Showcase JJ's conflict-free merging advantages

### 4.1 Data Model for Pull Requests
**Tasks for Claude Code:**
- Design database schema for:
  - PullRequests/ChangeRequests table:
    - `id`, `title`, `description`, `status` (open/merged/closed)
    - `author_id`, `repository_id`
    - `source_bookmark`, `target_bookmark` (default: `main`)
    - `head_change_id` (JJ change ID at PR creation)
    - `created_at`, `updated_at`, `merged_at`, `closed_at`
  - Comments table:
    - `id`, `pull_request_id`, `user_id`, `body`
    - `change_id` (if comment on specific change)
    - `file_path`, `line_number` (for inline comments)
    - `created_at`, `updated_at`
  - Reviews table:
    - `id`, `pull_request_id`, `reviewer_id`
    - `status` (pending/approved/changes_requested)
    - `created_at`, `updated_at`
- Create Ecto schemas and migrations
- Add indexes for query performance

### 4.2 Pull Request Creation
**Tasks for Claude Code:**
- Create "New Pull Request" UI
- Select source and target bookmarks
- Auto-detect changes between bookmarks
- Show diff preview before creating PR
- Add title and description fields
- Support draft PRs
- Validate that changes exist and can be merged

### 4.3 Pull Request Viewing & Diff Display
**Tasks for Claude Code:**
- Create LiveView for PR list (filterable: open/closed/merged, by author)
- Create detailed PR view showing:
  - Title, description, author, timestamps
  - Status badges (open/merged/closed/draft)
  - List of changes/commits in the PR
  - Full unified diff or file-by-file diff
  - Merge conflict status (if any)
- Implement syntax-highlighted diff viewer
- Add file tree navigator for large PRs
- Show "mergeable" status indicator

### 4.4 Code Review Features
**Tasks for Claude Code:**
- Inline comment system:
  - Click line number to add comment
  - Reply to comments (threaded discussions)
  - Resolve/unresolve comment threads
- Review approval workflow:
  - Approve/Request Changes/Comment buttons
  - Show approval status from reviewers
  - Required approvals before merge (configurable)
- Real-time updates via Phoenix LiveView
- Email notifications for PR activity (optional)

### 4.5 Merging Pull Requests
**Tasks for Claude Code:**
- Implement merge strategies:
  - **Rebase and merge** (recommended for JJ)
  - **Squash and merge** (combine changes into one)
  - **Merge commit** (traditional Git-style merge)
- Leverage JJ's conflict-free merging:
  - Show automatic conflict resolution
  - Preview merge result before executing
  - Highlight JJ's advantages over Git
- Add merge button with confirmation
- Update PR status to "merged" after successful merge
- Add "Close without merging" option
- Handle merge conflicts gracefully (though JJ minimizes these)

### 4.6 Branch Protection Rules (Future Enhancement)
**Considerations:**
- Require PR reviews before merging to main
- Require status checks to pass (CI/CD integration)
- Restrict who can merge to protected branches
- Auto-delete source bookmark after merge

---

## Phase 5: Git Remote Compatibility Layer

### 5.1 Git Protocol Support
**Tasks for Claude Code:**
- Research Git HTTP protocol
- Implement basic Git HTTP endpoints:
  - `/info/refs`
  - `/git-upload-pack`
  - `/git-receive-pack`
- Use JJ's Git backend to serve these requests
- Test with `git clone`, `git push`, `git pull`

### 5.2 JJ Push/Pull Integration
**Tasks for Claude Code:**
- Create endpoints for JJ operations
- Implement authentication for push operations
- Handle bookmark/branch management
- Automatically create bookmarks for pushed changes
- Test `jj git clone`, `jj git push` against your server
- Update PR head when new changes pushed to source bookmark

---

## Phase 6: Federation Foundations

### 6.1 ActivityPub Research & Setup
**Tasks for Claude Code:**
- Install/configure ActivityPub Elixir library
- Create actor model for repositories
- Implement WebFinger discovery
- Set up basic inbox/outbox endpoints

### 6.2 ForgeFed Protocol Implementation
**Tasks for Claude Code:**
- Study ForgeFed spec (includes federated PRs/merge requests)
- Implement basic ForgeFed vocabulary
- Create data models for federated objects:
  - Repository
  - Push events
  - Pull Requests (federated across instances!)
  - Comments and reviews
- Test federation between two local instances

### 6.3 Federated Pull Requests
**Tasks for Claude Code:**
- Enable PRs from forks on other instances
- Federate PR comments and reviews
- Handle cross-instance notifications
- Sync PR status across instances
- Test full PR workflow across federated instances

### 6.4 Instance Discovery & Following
**Tasks for Claude Code:**
- Implement repository following across instances
- Handle incoming federation requests
- Create UI for browsing federated repositories
- Set up async job processing with Oban for federation tasks

### 6.5 Federated Identity (Future)
**Considerations:**
- Link GitHub identity with federated identity
- Allow users to verify ownership across instances
- Support multiple OAuth providers (GitLab, Codeberg, etc.)
- Implement local account option for GitHub-independent users

---

## Phase 7: Deployment & Infrastructure

### 7.1 Raspberry Pi Deployment
**Tasks for Claude Code:**
- Optimize Docker images for ARM64
- Create deployment script
- Set up systemd services
- Configure log rotation
- Implement backup strategy (include PR data!)

### 7.2 Cloudflare Tunnel Setup
**Tasks for Claude Code:**
- Create cloudflared configuration
- Set up tunnel authentication
- Configure DNS in Cloudflare
- Test external access
- Set up SSL/TLS
- Update GitHub OAuth callback URL for production domain

### 7.3 Monitoring & Observability
**Tasks for Claude Code:**
- Add Phoenix LiveDashboard
- Set up error tracking (AppSignal or Sentry)
- Create health check endpoints
- Implement basic metrics collection
- Add Postgres query monitoring
- Track PR metrics (time to merge, review time, etc.)

---

## Phase 8: Polish & Launch

### 8.1 Documentation
**Tasks for Claude Code:**
- Generate API documentation
- Write user guide for:
  - Creating repositories
  - Pushing with JJ
  - Creating and reviewing pull requests
  - Federation basics
  - GitHub authentication setup
- Create developer documentation
- Document JJ's advantages in PR workflow

### 8.2 Testing
**Tasks for Claude Code:**
- Write ExUnit tests for core modules
- Add integration tests for JJ operations
- Test PR creation, review, and merge workflows
- Test federation scenarios
- Test OAuth flow
- Load testing on Raspberry Pi

### 8.3 Community Features
**Tasks for Claude Code:**
- Add repository README rendering
- Implement user profiles (with GitHub avatar integration)
- Create activity feeds (including PR activity)
- Basic search functionality (repos, PRs, users)
- Optional: Import GitHub SSH keys for authenticated users
- Trending repositories and PRs

