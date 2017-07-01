module.exports =
  oauth2:
    tokenUrl: process.env.TOKENURL
    verifyUrl: process.env.VERIFYURL
    scope: process.env.OAUTH2_SCOPE?.split(' ') || [
        'User'
      ]
