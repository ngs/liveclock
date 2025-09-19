# Match Repository SSH Access Setup

This guide explains how to configure SSH Deploy Key for GitHub Actions to access your private Match certificates repository.

## Prerequisites

- A private GitHub repository for Match certificates (e.g., `github.com/ngs/certificates`)
- Admin access to both the LiveClock and Match repositories

## Setup Instructions

### 1. Generate SSH Key Pair

```bash
ssh-keygen -t ed25519 -C "github-actions-match" -f match_deploy_key -N ""
```

This creates two files:
- `match_deploy_key` - Private key (keep secret!)
- `match_deploy_key.pub` - Public key

### 2. Add Deploy Key to Match Repository

1. Go to your Match repository: `https://github.com/[username]/certificates/settings/keys`
2. Click **"Add deploy key"**
3. Fill in:
   - **Title**: `GitHub Actions - LiveClock`
   - **Key**: Paste the entire contents of `match_deploy_key.pub`
   - **Allow write access**: ✅ Must be checked (Match needs to update certificates)
4. Click **"Add key"**

### 3. Add Private Key to LiveClock Repository Secrets

1. Go to LiveClock repository: `https://github.com/ngs/liveclock/settings/secrets/actions`
2. Click **"New repository secret"**
3. Fill in:
   - **Name**: `MATCH_DEPLOY_KEY`
   - **Value**: Paste the entire contents of `match_deploy_key` including:
     ```
     -----BEGIN OPENSSH PRIVATE KEY-----
     [key content]
     -----END OPENSSH PRIVATE KEY-----
     ```
4. Click **"Add secret"**

### 4. Update MATCH_GIT_URL Secret

Ensure your `MATCH_GIT_URL` secret uses SSH format:

```
git@github.com:ngs/certificates.git
```

**NOT** `https://github.com/ngs/certificates`

## Verification

After setup, the GitHub Actions workflow will:
1. Install the SSH key
2. Configure Git to use SSH for GitHub
3. Successfully clone your Match repository

## Security Notes

- The private key is encrypted in GitHub Secrets
- Only GitHub Actions runners can access the key during workflow execution
- The key is never exposed in logs
- Consider rotating the key periodically

## Troubleshooting

### Error: "Permission denied (publickey)"
- Verify the Deploy Key is added to the Match repository
- Ensure "Allow write access" is enabled
- Check the private key was copied correctly (including header/footer)

### Error: "Host key verification failed"
- The workflow automatically runs `ssh-keyscan github.com`
- If this fails, GitHub may be experiencing issues

### Error: "Could not read from remote repository"
- Verify `MATCH_GIT_URL` uses SSH format: `git@github.com:user/repo.git`
- Confirm the repository exists and is accessible

## Clean Up

After successful setup, delete the local key files:

```bash
rm match_deploy_key match_deploy_key.pub
```

Never commit these files to version control!