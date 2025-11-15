<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="utf-8">
    <title>Seu link mágico</title>
</head>
<body style="font-family: system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif; background: #f8fafc; color: #0f172a; padding: 32px;">
<table role="presentation" width="100%" cellpadding="0" cellspacing="0">
    <tr>
        <td align="center">
            <table role="presentation" width="100%" cellpadding="24" cellspacing="0" style="max-width: 500px; background: #ffffff; border-radius: 16px; box-shadow: 0 16px 40px rgba(15,23,42,0.08);">
                <tr>
                    <td>
                        <h1 style="margin-top: 0; font-size: 24px; font-weight: 700; color: #0f172a;">Seu link mágico chegou ✨</h1>
                        <p style="font-size: 14px; line-height: 1.6; margin-bottom: 24px; color: #334155;">
                            Clique no botão abaixo para acessar seu painel do EasyTrip. O link expira em 15 minutos.
                        </p>
                        <p style="text-align: center; margin-bottom: 32px;">
                            <a href="{{ $url }}" style="display: inline-block; padding: 12px 28px; background: #0ea5e9; color: #ffffff; text-decoration: none; font-weight: 600; border-radius: 999px;">
                                Acessar agora
                            </a>
                        </p>
                        <p style="font-size: 12px; line-height: 1.6; color: #64748b; margin-bottom: 24px;">
                            Se você não solicitou este acesso, pode ignorar este email com segurança.
                        </p>
                        <p style="font-size: 14px; margin: 0; color: #334155;">
                            Obrigado,<br>
                            {{ config('app.name') }}
                        </p>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</body>
</html>
