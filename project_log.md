### Development Workflow

1. **Incremental Progress**: Complete one phase at a time
2. **Validation**: Test each feature before moving forward
3. **Documentation**: Keep notes on what works and what doesn't
4. **Community Feedback**: Share progress with JJ community early

### Key Milestones

- [x] **Milestone 1**: Phoenix app running in Docker with auth (local + GitHub OAuth)
- [ ] **Milestone 2**: Can create and view a JJ repository via web UI
- [ ] **Milestone 3**: Pull request creation and review workflow functional
- [ ] **Milestone 4**: Can `jj git push` to your server and auto-create PRs
- [ ] **Milestone 5**: PR merging with JJ's conflict-free advantages demonstrated
- [ ] **Milestone 6**: Basic federation between two instances (including federated PRs)
- [ ] **Milestone 7**: Deployed on Raspberry Pi and accessible via Cloudflare
- [ ] **Milestone 8**: First external user successfully creates and merges a PR

---

## Technical Stack Summary

- **Language**: Elixir
- **Framework**: Phoenix + LiveView
- **Database**: PostgreSQL
- **Cache/Jobs**: Redis + Oban
- **VCS**: Jujutsu (JJ) with Git backend
- **Authentication**: phx.gen.auth + Ueberauth (GitHub OAuth)
- **Federation**: ActivityPub + ForgeFed
- **Deployment**: Docker on Raspberry Pi
- **Networking**: Cloudflare Tunnels
- **Monitoring**: Phoenix LiveDashboard

---

## Authentication Strategy

### Multi-Provider Approach
1. **Local accounts**: Email/password via phx.gen.auth
2. **GitHub OAuth**: Primary social login (implemented first)
3. **Future providers**: GitLab, Codeberg, etc.
4. **Federated identity**: Link accounts across instances

### GitHub OAuth Implementation Details

**Dependencies:**
```elixir
{:ueberauth, "~> 0.10"},
{:ueberauth_github, "~> 0.8"}
```

**Environment Variables:**
```bash
GITHUB_CLIENT_ID=your_client_id
GITHUB_CLIENT_SECRET=your_client_secret
```

**User Schema Updates:**
- Add `github_id` field (string, unique, nullable)
- Add `avatar_url` field (string, nullable)
- Add `provider` field (string, default: "local")

**Routes:**
```elixir
scope "/auth", ReponetWeb do
  pipe_through :browser
  get "/:provider", AuthController, :request
  get "/:provider/callback", AuthController, :callback
end
```

**Benefits:**
- Reduces signup friction for developers
- Pre-populated user profiles
- Bridge from GitHub to federated platform
- Familiar authentication flow

---

## Pull Request Workflow Design

### PR Lifecycle
1. **Creation**: Developer pushes to bookmark, creates PR via UI
2. **Review**: Reviewers comment inline, request changes, or approve
3. **Updates**: Author pushes new changes, PR auto-updates
4. **Merge**: Once approved, PR merged using JJ's conflict-free merging
5. **Cleanup**: Source bookmark optionally deleted

### JJ-Specific Advantages to Highlight
- **Conflict-free merging**: JJ handles conflicts automatically in many cases
- **Change evolution**: Track how changes evolve over time
- **Rebase simplicity**: Rebasing is safer and more intuitive in JJ
- **No detached HEAD**: Eliminates a common Git pain point

### UI Inspiration (but better)
- Clean, fast LiveView-based interface
- Real-time collaboration (like Google Docs for code review)
- Mobile-friendly PR review
- Keyboard shortcuts for power users
- Dark mode support

---

## Future Considerations

### Beyond MVP
- Issues/tickets system (integrated with PRs)
- CI/CD integration (run tests on PR creation)
- Code review tools (side-by-side diff, suggested changes)
- Advanced search (code search within PRs)
- Mobile-responsive design
- API for third-party integrations
- SSH key import from GitHub
- Multiple OAuth provider support (GitLab, Codeberg, Bitbucket)
- Draft PRs and PR templates
- Auto-merge when checks pass
- Dependency update PRs (like Dependabot)

### PR-Specific Enhancements
- PR labels and milestones
- Assignees and reviewers
- Linked issues
- PR templates
- Code owners (auto-assign reviewers)
- Required status checks
- Auto-rebase when target bookmark updates
- Merge queue for busy repositories

### Scaling Considerations
- Multi-instance federation testing
- Repository mirroring/caching
- CDN for static assets
- Database replication
- Migration path from Raspberry Pi to cloud
- PR notification optimization (email digests, webhooks)

---

## Resources

- [Jujutsu Documentation](https://jj-vcs.github.io/jj/)
- [ForgeFed Specification](https://forgefed.org/) - includes federated merge requests!
- [ActivityPub Protocol](https://www.w3.org/TR/activitypub/)
- [Phoenix Framework](https://www.phoenixframework.org/)
- [Phoenix LiveView](https://hexdocs.pm/phoenix_live_view/)
- [Ueberauth Documentation](https://hexdocs.pm/ueberauth/)
- [Ueberauth GitHub Strategy](https://hexdocs.pm/ueberauth_github/)
- [Elixir Forum](https://elixirforum.com/)

---

## Notes

- This is an ambitious project - pace yourself!
- **Pull requests are core functionality** - prioritize them early
- The JJ community is small but engaged - reach out for feedback
- Document your learnings - this could help others build on JJ
- Consider open-sourcing the platform itself to encourage adoption
- GitHub OAuth provides a familiar onboarding experience for developers
- Keep local account option for users who want GitHub-independent identity
- **JJ's conflict-free merging is your competitive advantage** - showcase it in PR workflow!
- LiveView makes real-time PR collaboration feel magical
- Federation + PRs = truly decentralized code collaboration
