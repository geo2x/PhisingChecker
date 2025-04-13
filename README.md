=====================================================================================
                         Gordon's Phishing Guard
=====================================================================================

What it does:
-------------------------------------------------------------------------------------
- checks your emails for phishing stuff (like bad links or sketchy words)
- looks at URLs in the email, sees if they got login pages or passwords
- checks how old the website is (new ones are bad news)
- makes sure SSL certs are good, no expired junk
- reads email headers, like who sent it or reply-to tricks
- flags stuff like "urgent" or "login now" in the subject or body
- gives a score, if its high (over 80) its probs phishing, 50-80 be careful

How to use it:
-------------------------------------------------------------------------------------
1. save as phishing_detector.py (or whatever, just .py)
2. need python 3, i used 3.10 but prob works with others
3. install stuff: pip install requests beautifulsoup4 python-whois
4. put your email and password in the code (i used gmail, change imap if u use another)
5. run it: python phishing_detector.py
6. it grabs last 5 emails, checks em, prints scores
7. high score means danger, low is prolly fine

Warnings:
-------------------------------------------------------------------------------------
- DONT use your real email password, use an app password (google it for gmail)
- only checks emails you got access to, don’t hack nobody
- might crash if websites are slow or ur internet sucks
- i tested on my gmail, other emails might need tweaks

=====================================================================================
note: 1/4 this was AI (mostly debugging), always like to state that though 
half my own code. i checked for errors but always double 
check me :) <3
=====================================================================================
