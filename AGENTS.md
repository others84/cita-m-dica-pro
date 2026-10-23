<!-- LOVABLE:BEGIN -->
> [!IMPORTANT]
> This project is connected to [Lovable](https://lovable.dev). Avoid rewriting
> published git history — force pushing, or rebasing/amending/squashing commits
> that are already pushed — as it rewrites history on Lovable's side and the
> user will likely lose their project history.
>
> Commits you push to the connected branch sync back to Lovable and show up in
> the editor, so keep the branch in a working state.
<!-- LOVABLE:END -->

- El marco autenticado de `php-app` usa un menú lateral claro y una barra superior adaptable; preservar esa estructura al agregar navegación porque es el patrón visual aprobado.
- The PHP WhatsApp adapter reads only CONFIG_WHATSAPP_EVOLUTION via dedicated stored procedures; keep legacy Meta configuration untouched to avoid interpreting Meta tokens as Evolution keys.
- Store the WhatsApp OTP message in the Evolution configuration and render it through the shared WhatsApp adapter for both real codes and test sends; substitute validity from the OTP model so editing wording cannot change verification rules.
