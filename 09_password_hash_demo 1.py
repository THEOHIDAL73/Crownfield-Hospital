#!/usr/bin/env python3
"""Pure-stdlib, local educational demonstration of PBKDF2 password hashing.
No known user password or hospital data is required. Does not modify MySQL.
"""
import os,hashlib,hmac,getpass

def hash_password(secret):
    salt=os.urandom(16)
    digest=hashlib.pbkdf2_hmac('sha256',secret.encode('utf-8'),salt,600_000)
    return 'pbkdf2_sha256$600000$'+salt.hex()+'$'+digest.hex()

def verify(secret, encoded):
    algorithm,count,salt,digest=encoded.split('$')
    if algorithm!='pbkdf2_sha256': return False
    actual=hashlib.pbkdf2_hmac('sha256',secret.encode('utf-8'),bytes.fromhex(salt),int(count))
    return hmac.compare_digest(actual,bytes.fromhex(digest))

if __name__=='__main__':
    secret=getpass.getpass('Enter a THROWAWAY demo password (not saved): ')
    if not secret: raise SystemExit('Choose a nonempty test password')
    first,second=hash_password(secret),hash_password(secret)
    print('Two independently salted digest values differ:',first!=second)
    print('Correct password verifies:',verify(secret,first))
    print('Wrong password rejected:',not verify(secret+'wrong',first))
    print('Digest format:',first.split('$')[0],'iterations',first.split('$')[1])
    del secret
