#import "@preview/polylux:0.4.0": *

#let HANDOUT_MODE = false
#enable-handout-mode(HANDOUT_MODE)

// colour configurations
#let SECONDARY_COLOR = rgb("#fafafa")
#let PRIMARY_COLOR = rgb("#be2b31")
#let TEXT_COLOR = black.lighten(13%)

// document general
#let location = "Astrophysics Developer Group"
#let date = datetime(year: 2025, month: 5, day: 9)
#let datefmt = "[day] [month repr:long] [year]"

// utility functions
#let black(t, ..args) = text(weight: "black", t, ..args)
#let hl(t, ..args) = black(fill: PRIMARY_COLOR, ..args, t)

#let _setgrp(img, grp, display: true) = {
  let key = "id=\"" + grp + "\""
  let pos1 = img.split(key)
  if display {
    pos1.at(1) = pos1.at(1).replace("display:none", "display:inline", count: 1)
  } else {
    pos1.at(1) = pos1.at(1).replace("display:inline", "display:none", count: 1)
  }
  pos1.join(key)
}

#let cbox(b, width: 100%) = block(
  inset: 15pt,
  radius: 3pt,
  width: width,
  fill: PRIMARY_COLOR,
  text(fill: SECONDARY_COLOR, b),
)

#let setgrp(img, ..grps, display: true) = {
  grps
    .pos()
    .fold(
      img,
      (acc, grp) => {
        _setgrp(acc, grp, display: display)
      },
    )
}

#let animsvg(img, display_callback, ..frames, handout: false) = {
  let _frame_wrapper(_img, hide: (), display: ()) = {
    setgrp((setgrp(_img, ..hide, display: false)), ..display, display: true)
  }
  if handout == true {
    let final_image = frames
      .pos()
      .fold(img, (im, args) => _frame_wrapper(im, ..args))
    display_callback(1, final_image)
  } else {
    let output = ()
    let current_image = img
    for args in frames.pos().enumerate() {
      let (i, frame) = args
      current_image = _frame_wrapper(
        current_image,
        ..frame,
      )
      let this = display_callback(i + 1, current_image)
      output.push(this)
    }
    output.join()
  }
}

#let only-last-handout(..blocks, fig: false, handout: false, fig-num: 1) = {
  if handout == true {
    blocks.at(-1)
  } else {
    let output = ()
    context {
      counter(figure).update(fig-num)
      for blk in blocks.pos().enumerate() {
        let (i, b) = blk
        [
          #only(i + 1, b)
        ]
      }
    }
    output.join()
  }
}

// page configuration
#set par(leading: 8pt)
#set text(size: 20pt, font: "Atkinson Hyperlegible Next", fill: TEXT_COLOR)
#show raw.where(block: true): c => block(
  stroke: 1pt,
  inset: 7pt,
  radius: 1pt,
  fill: white,
  text(size: 12pt, c),
)

#let seperator = [#h(10pt)/#h(10pt)]
#set page(
  paper: "presentation-4-3",
  margin: (top: 0.4cm, left: 0.4cm, right: 0.4cm, bottom: 1.0cm),
  fill: SECONDARY_COLOR.darken(10%),
  footer: text(
    size: 12pt,
    [Fergus Baker #seperator CC BY-NC-SA 4.0 #seperator #location #seperator #date.display(datefmt) #h(1fr) #toolbox.slide-number],
  ),
)

// functions for drawing slides
#let _nofooter_sl(body) = [
  #set page(margin: 0.4cm, footer: none)
  #body
]

#let cline(width: 1fr) = box(
  baseline: -12pt,
  height: 7pt,
  width: width,
  fill: PRIMARY_COLOR,
)
#let titlefmt(t) = block(
  inset: 0pt,
  text(
    tracking: -2pt,
    weight: "bold",
    size: 50pt,
    [#cline(width: 1cm) #t #cline()],
  ),
)

#let sl(body, title: none, footer: true, inset: 0.5cm) = {
  let contents = [
    #if title != none [
      #titlefmt(title)
      #v(-inset + 0.2cm)
    ]
    #block(inset: inset, fill: SECONDARY_COLOR, height: 1fr, width: 100%, body)
  ]

  if footer [
    #slide(contents)
  ] else [
    #_nofooter_sl(contents)
  ]
}

// main body

#let main_title = sl(footer: false, inset: 0.2cm)[
  #grid(
    columns: (33%, 1fr),
    column-gutter: 0.2cm,
    [
      #block(inset: 0.5cm, width: 100%, height: 100%)[
        #set align(center)
        #v(1fr)
        #image("assets/key.svg", height: 100%)
      ]
    ],
    block(inset: 0.3cm)[
      #text(tracking: -2pt, size: 30pt)[
        #set par(spacing: 0pt, justify: true)
        #text(size: 80pt, fill: PRIMARY_COLOR, weight: "black")[GPG,]\
        #text(
          font: "Adelphe Germinal",
          size: 70pt,
          weight: "black",
        )[cryptography,]\
        #v(20pt)
        #text(size: 50pt, weight: "black")[_and_]\
        #v(20pt)
        #text(
          font: "Alma Virgo",
          size: 80pt,
          fill: PRIMARY_COLOR,
          weight: "black",
        )[digital\ signatures]
        #v(10pt)
      ]

      #v(1fr)
      #grid(
        columns: (50%, 1fr),
        [

          #text(fill: PRIMARY_COLOR)[*Fergus Baker*]
          #v(-0.4cm)
          #set text(size: 16pt)
          #v(-0.2cm)
          #location #h(1fr)
          #v(-0.2cm)
          #date.display(datefmt)
        ],
        [
          #set align(right)
          #set align(bottom)
          #image("assets/bristol-logo.svg", height: 1.5cm)
        ],
      )
    ],
  )
]

#main_title

#slide()[
  #set page(footer: none)
  #set align(horizon)
  #grid(
    columns: (50%, 1fr),
    [
      #set align(center)
      #set text(size: 80pt, weight: "black")
      Wins
    ],
    [ ],
  )
]

#slide()[
  #set page(footer: none)
  #set align(horizon)
  #grid(
    columns: (50%, 1fr),
    [
      #set text(size: 80pt, weight: "black")
      #set align(center)
      Issues
    ],
    [ ],
  )
]

#main_title

#sl()[
  #v(2cm)
  #[
    #set text(size: 30pt)
    #set align(center)
    Aitchkey ekey elkey elkey opan aitchkey ohkey wopan akey arkey epan wokey ohkey upan?

    #uncover("2-")[
      #hl[Aitch]key #hl[e]key #hl[el]key #hl[el]key #hl[o]pan #hl[aitch]key #hl[oh]key #hl[wo]pan #hl[a]key #hl[ar]key #hl[e]pan #hl[wo]key #hl[oh]key #hl[u]pan?
    ]

    #uncover("3-")[Hello how are you?]
  ]
  #uncover("4-")[Encryption and decryption rule:
    - Spell out each letter,
    - Add #hl[-key].
    - Unless it's the last letter of a word, then add #hl[-pan].
    - (Special treatment for `w` to avoid giving the game away)
  ]

  #uncover("5-")[#cbox[This is an *asymmetric cryptosystem*, a variation of *pig latin* and related *language games*.]]
]

#sl(title: "Cryptography for security")[
  Encryption is a way of #hl[locking information]
  - Only those with the #hl[key] (or passphrase) can unlock the information.
  - Avoid others seeing what you are sending.

  #uncover("2-")[#grid(
      columns: (60%, 1fr),
      [
        #set align(center)
        #image("assets/Caesar_cipher_left_shift_of_3.svg.png", height: 4.0cm)
      ],
      [
        #hl[Caesar cipher] `ROTn`: offset each letter by some number `n`:
        ```
        V bjr Srethf n cvag
        ```

        #text(
          size: 11pt,
        )[Image by #link("https://commons.wikimedia.org/w/index.php?curid=30693472")[Matt_Crypto - Public Domain]]
      ],
    )
  ]

  #uncover("3-")[More than that, it is for #hl[security]
    - #hl[Hide password files] or photographs of my passport
    - Send a private message to a #hl[specific recipient]
  ]

  #uncover("4-")[#cbox[
      #set align(center)
      Used by *journalists*, *lawyers*, *banks*, *databases*, *messaging apps*, the *military*, and more!

      Anywhere where you might have an interest to stop _someone else_ from *seeing your information*.
    ]]

  #uncover("5-")[#align(center, text[It's for #hl[privacy].])]
]

#sl(footer: false)[
  #v(1cm)
  #[
    #set align(center)
    #image("assets/digital-signature-email.png")

    ```
    Content-Type: application/pgp-signature; name="signature.asc"

    -----BEGIN PGP SIGNATURE-----

    iHUEABYKAB0WIQQU5eht4omtFEu0E7r4SsTC+9kDLQUCaBoTzwAKCRD4SsTC+9kD
    LS8yAP9WLu1aB9RrNW+b3FbGIHoazq0cfFEbIPHGB3DJcYzapAD/Wxpoyi8dlTGW
    cf+STpP/ve3cwbWGPo0VpupLb4fDlwg=
    =j11c
    -----END PGP SIGNATURE-----

    ```
  ]

  #v(2cm)

  #uncover("2-")[This is my #hl[cryptographic signature].
    - It is #hl[uniquely generated] for each email I write.
    - Can be used to verify that the contents of the email came from me.
  ]
]

#sl(title: "Cryptography for trust")[

  ```
  From: Trevor "T" Excellent <trevor@excellent-research-group.com>
  Subject: Professorship Gig

  Wazzaaaaap,

  We at the Excellent Research want to invite you to be our next Big Influence, Big Money, Big Impact Professor of Psychoactive Hallucinatory Astrophysics. You down?
  ```
  #uncover("2-")[How do you know if a message _really_ came from someone?]


  #uncover("3-")[#hl[Digital signatures] generate a cryptographic signature that verifies the content and sender.
    - A signature is created with a private key, and the public key can verify its authenticity.
    - Digital signatures even carry #hl[legal precedent] in many countries (not the UK though 🙁).
  ]

  #uncover("4-")[#cbox[
      #set align(center)
      Used in *software distribution*, *emails*, for *commit signing*, and so on.

      Anywhere where you might want to ensure someone can *verify* that you made something.
    ]]

  #uncover("5-")[#align(center, text[It's for #hl[ease of mind].])]
]

#sl(title: "Terminology")[
  #grid(
    columns: (50%, 1fr),
    [
      #hl[Symmetric Cryptosystem]
      #align(center, image("assets/combination-lock.png"))
      - The encryption system is the same as the decryption system.
      - The only system until ~1970.
      - How do you ensure only the recipient can decrypt?
      - Computationally fast.
    ],
    [
      #hl[Asymmetric Cryptosystem]
      #align(center, image("assets/padlock.png", width: 8cm))
      - The encryption system is #hl[distinct] from the decryption system.
      - Only #hl[one key] can decrypt the message.
      - Computationally slow.
    ],
  )
  #uncover("2-")[#cbox[Modern cryptography methods prefer *asymmetric cryptosystems* as a single recipient is guaranteed.]]
]

#sl(title: "Digital Keychains")[
  In #hl[asymmetric cryptosystems], you have a #hl[private] and a #hl[public] key.

  #align(center)[
    #image("assets/Public_key_encryption.svg.png", height: 10cm)
    #text(
      size: 11pt,
    )[By #link("By Davidgothberg - Own work, Public Domain, https://commons.wikimedia.org/w/index.php?curid=1028460")[Davidgothberg] - Public Domain ]
  ]

  - The private is #hl[only for you].
  - You can share the #hl[public with everyone].

  There are many programs and applications that implement such systems.
]

#sl(title: "GPG")[
  #grid(
    columns: (50%, 1fr),
    [
      GNU Privacy Guard (GPL 3.0)
      - First introduced in 1997.
      - A GPL implementation of #hl[OpenPGP standards].
      - PGP is #hl[Pretty Good Privacy].

      #v(1cm)

      #uncover("2-")[
        PGP is proprietary software, but the OpenPGP standards are open and free.

        Broadly speaking: uses #hl[asymmetric keys] to encrypt a #hl[symmetric key].]

      #uncover("3-")[You probably already have it installed, but otherwise:
        ```bash
        brew install gnupg

        # Or for Debian-based
        sudo apt install gnupg2

        gpg --version
        ```
      ]
    ],
    [
      #set align(center)
      #image("assets/gnupg.png", width: 7cm)
      #uncover("2-")[#image("assets/PGP_diagram.svg.png", width: 10cm)
        #text(
          size: 11pt,
        )[Image by #link("https://commons.wikimedia.org/w/index.php?curid=19680258")[xaedes & jfreax & Acdx] CC BY-SA 3.0, ]
      ]
    ],
  )
]

#sl(title: "Getting started")[
  #grid(
    columns: (50%, 1fr),
    [
      ```bash
      # Generate a strong key
      gpg --full-generate-key

      # Export your public key
      gpg --export --armor [key id] > pub_key.asc

      # Generate a revocation certificate
      gpg --gen-revoke --output revoke.asc [key id]
      ```
      Be sure to #hl[backup your private keys] and #hl[revocation certificates].

      #uncover("2-")[Then, #hl[share your public key]!

        ```bash
        gpg --send-keys [key id]

        # Get your friends
        gpg --recv-keys [key id]

        # Get my University public key
        gpg --recv-keys F84AC4C2FBD9032D
        ```
      ]
    ],
    [
      #set align(center)
      #image("assets/the-crew-henry-holiday.png", height: 14cm)
    ],
  )
  #uncover("3-")[Build a #hl[web of trust]. Once you have someone's key and you can verify it, they can #hl[sign other people's keys] they trust.]
]

#sl(footer: false)[
  #v(1cm)
  #[
    #set par(spacing: 0pt)
    #set align(center)
    #text(
      size: 30pt,
    )[The #hl[Astrophysics Developer Group] 1#super("st") annual]\
    #v(20pt)
    #text(
      size: 62pt,
      weight: "black",
      fill: PRIMARY_COLOR,
    )[🎉 Key signing party! 🎉]
  ]
  #v(10pt)

  #set align(center)
  #v(1cm)

  ```bash
  gpg --recv-keys [key id]

  # Verify the fingerprint
  gpg --fingerprint [key id]

  # Sign the key
  gpg --sign-key [key id]
  # If you have multiple private keys, choose which one to use
  gpg --default-key [your key id] --sign-key [key id]

  # Return the key
  gpg --send-keys [key id]
  # Or to a specific server
  gpg --keyserver [keyserver] --send-keys [key id]
  ```
]

#sl(title: "Encryption")[
  There are graphical tools, but on the command line it's simple:
  #align(center)[
    ```bash
    gpg --encrypt --armor --recipient [recipient name] my-secret-message.txt
    gpg -ear [recipient] my-secret-message.txt

    # Exchange messages with someone

    # Decrypt with
    gpg --decrypt my-secret-message.asc
    gpg -d my-secret-message.asc
    ```
  ]

  Only the #hl[recipient can decrypt].

  For #hl[symmetric] encryption:
  #align(center)[
    ```bash
    gpg --symmetric --armor my-secret-message.txt
    gpg -ca my-secret-message.txt

    # Exchange messages with someone

    # Decrypt as before
    ```
  ]
  Anyone with the #hl[passphrase] can decrypt.

]

#sl(title: "Signing")[
  Signing gives the recipient the #hl[ability to verify] that:
  - A message originated from you.
  - Has not been tampered with.

  Signing with GPG includes a compressed form of the origin file.

  #align(center)[
    ```bash
    gpg --default-key [key to use] --armor --sign my-message

    # Reading a compressed signed message
    gpg --decrypt my-message.asc

    # To include the original message in cleartext in the output
    gpg --default-key [key to use] --clearsign my-message

    # Signing can be combined with encryption
    gpg --default-key [signing key] --sign \
        --encrypt --armor --recipient [recipient name] \
        my-secret-message.txt

    # Verifying a message
    gpg --verify [signed file]

    ```

  ]
  To create a detached signature (without the original contents) use `--detach-sig`.

]

#sl(title: "Some final notes")[
  #hl[Backup your keys] and #hl[revocation certificates].

  Configure git to automatically sign commits:
  ```toml
  [user]
      name = fjebaker
      email = fergus@cosroe.com
      signingkey = 362FD643587D5482
  [commit]
      gpgsign = true

  ```

  Setting up your #hl[email client] with GPG:
  https://emailselfdefense.fsf.org/en/

  - Encrypt everything, not just important things.
  - Don't create too many keys (becomes hard to keep track of).
  - Share your #hl[public key] far and wide.
  - Teach others!

  #v(1fr)
  #set align(center)
  #cbox(width: 50%)[
    Have *fun with it* \<3]
  #v(2cm)
]

#slide()[
  #show link: l => text(fill: blue.lighten(40%), l)
  #set page(fill: PRIMARY_COLOR, footer: none)
  #set text(fill: SECONDARY_COLOR)
  #v(0.5cm)
  #par(spacing: 0pt, text(size: 105pt, weight: "bold")[Summary])

  #v(0.5cm)

  - Share your *public key* with *everyone*.
  - Backup your *private key* and your *revocation certificate*.
  - Sign things, encrypt things, keep the world private.
  - Teach your friends.

  #par(spacing: 20pt, text(size: 30pt)[*Thank you! \<3*])

  #set align(right)
  #v(1fr)
  *Contact:* #link("fergus.baker@bristol.ac.uk") \
  #link("https://github.com/fjebaker") \
  #link("www.cosroe.com") \
  #set text(size: 15pt)
  \
  _Fonts:_ Atkinson Hyperlegible Next, \ Adelphe Germinal, Alma Virgo \
  _Slides_ made with Typst.
]

#slide()[
  #set page(footer: none)
  #grid(
    columns: (50%, 1fr),
    [
      #set text(size: 80pt, weight: "black")
      #set align(horizon)
      #set align(center)
      AOB
    ],
    [
      #set align(horizon)
      #set align(center)
      #v(1cm)
      #uncover("2-")[#image("assets/orly-book-cover.png", height: 16cm)]
    ],
  )
]
