<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>RanciLab - Control de Rancidez Lipídica</title>
    <!-- Google Fonts & Bootstrap Icons -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <style>
        :root {
            --primary-navy: #0f172a;
            --primary-teal: #0d9488;
            --teal-light: #ccfbf1;
            --teal-accent: #14b8a6;
            --bg-gradient-top: #e6f7f5;
            --bg-gradient-bottom: #f8fafc;
            --card-border: #e2e8f0;
            --text-dark: #0f172a;
            --text-muted: #64748b;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background: linear-gradient(180deg, #dcfce7 0%, #e0f2fe 30%, #f8fafc 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 24px 16px;
            color: var(--text-dark);
        }

        .auth-container {
            width: 100%;
            max-width: 440px;
            display: flex;
            flex-direction: column;
            gap: 14px;
        }

        /* Top System Status Bar */
        .system-status-bar {
            background: rgba(255, 255, 255, 0.85);
            backdrop-filter: blur(8px);
            border: 1px solid rgba(203, 213, 225, 0.7);
            border-radius: 12px;
            padding: 8px 14px;
            font-size: 0.72rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 6px rgba(0,0,0,0.02);
        }

        .status-badge {
            background: #dcfce7;
            color: #15803d;
            font-weight: 700;
            padding: 2px 8px;
            border-radius: 6px;
            font-size: 0.68rem;
            letter-spacing: 0.5px;
        }

        .calibration-chip {
            background: #f0fdfa;
            border: 1px solid #ccfbf1;
            color: #0f766e;
            font-family: 'JetBrains Mono', monospace;
            font-size: 0.68rem;
            padding: 4px 8px;
            border-radius: 6px;
            text-align: center;
        }

        /* Main Card */
        .auth-card {
            background: #ffffff;
            border: 1px solid var(--card-border);
            border-radius: 20px;
            padding: 32px 28px 24px 28px;
            box-shadow: 0 10px 30px -10px rgba(15, 23, 42, 0.08), 0 4px 12px rgba(0,0,0,0.03);
            text-align: center;
        }

        .brand-logo-wrap {
            margin-bottom: 12px;
            display: inline-flex;
            flex-direction: column;
            align-items: center;
        }

        .brand-icon {
            width: 48px;
            height: 48px;
            background: linear-gradient(135deg, #0d9488 0%, #0284c7 100%);
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #ffffff;
            font-size: 22px;
            box-shadow: 0 6px 14px rgba(13, 148, 136, 0.25);
            margin-bottom: 8px;
        }

        .brand-title {
            font-size: 1.45rem;
            font-weight: 800;
            color: var(--primary-navy);
            letter-spacing: -0.5px;
        }

        .brand-subtitle {
            font-size: 0.70rem;
            text-transform: uppercase;
            font-weight: 700;
            color: var(--primary-teal);
            letter-spacing: 1.4px;
            margin-top: 2px;
        }

        .brand-desc {
            font-size: 0.75rem;
            color: var(--text-muted);
            margin-top: 6px;
            margin-bottom: 20px;
            line-height: 1.35;
        }

        /* Form Controls */
        .form-group {
            text-align: left;
            margin-bottom: 16px;
        }

        .form-label-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 6px;
        }

        .form-label-row label {
            font-size: 0.75rem;
            font-weight: 600;
            color: #334155;
        }

        .form-label-row .code-hint {
            font-size: 0.68rem;
            color: var(--text-muted);
            font-family: 'JetBrains Mono', monospace;
        }

        .input-group-custom {
            position: relative;
            display: flex;
            align-items: center;
        }

        .input-icon-left {
            position: absolute;
            left: 12px;
            color: #94a3b8;
            font-size: 15px;
        }

        .input-icon-right {
            position: absolute;
            right: 12px;
            color: #94a3b8;
            font-size: 15px;
            cursor: pointer;
            transition: color 0.15s ease;
        }

        .input-icon-right:hover {
            color: var(--primary-teal);
        }

        .form-control-custom {
            width: 100%;
            padding: 10px 38px 10px 38px;
            font-size: 0.85rem;
            font-family: 'Plus Jakarta Sans', sans-serif;
            border: 1.5px solid #e2e8f0;
            border-radius: 10px;
            background-color: #f8fafc;
            color: var(--text-dark);
            transition: all 0.2s ease;
        }

        .form-control-custom:focus {
            outline: none;
            border-color: var(--primary-teal);
            background-color: #ffffff;
            box-shadow: 0 0 0 3px rgba(13, 148, 136, 0.15);
        }

        .form-options {
            display: flex;
            align-items: center;
            justify-content: space-between;
            font-size: 0.72rem;
            color: var(--text-muted);
            margin: 14px 0 20px 0;
        }

        .form-check {
            display: flex;
            align-items: center;
            gap: 6px;
            cursor: pointer;
        }

        .form-check input {
            accent-color: var(--primary-teal);
            cursor: pointer;
        }

        /* Action Button */
        .btn-submit {
            width: 100%;
            background: linear-gradient(180deg, #1e293b 0%, #0f172a 100%);
            border: none;
            color: #ffffff;
            padding: 12px 16px;
            border-radius: 10px;
            font-size: 0.85rem;
            font-weight: 600;
            letter-spacing: 0.3px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            cursor: pointer;
            transition: all 0.2s ease;
            box-shadow: 0 4px 12px rgba(15, 23, 42, 0.2);
        }

        .btn-submit:hover {
            background: linear-gradient(180deg, #0f172a 0%, #020617 100%);
            transform: translateY(-1px);
            box-shadow: 0 6px 16px rgba(15, 23, 42, 0.25);
        }

        .btn-submit:active {
            transform: translateY(0);
        }

        /* Error Banner */
        .error-alert {
            background-color: #fef2f2;
            border: 1px solid #fecaca;
            color: #991b1b;
            font-size: 0.75rem;
            padding: 8px 12px;
            border-radius: 8px;
            margin-bottom: 16px;
            display: flex;
            align-items: center;
            gap: 8px;
            text-align: left;
        }

        /* Norms & Badges Section */
        .norms-section {
            background: rgba(255, 255, 255, 0.7);
            border: 1px solid rgba(226, 232, 240, 0.8);
            border-radius: 14px;
            padding: 14px;
            text-align: center;
        }

        .norms-header {
            font-size: 0.65rem;
            text-transform: uppercase;
            font-weight: 700;
            color: #64748b;
            letter-spacing: 0.8px;
            margin-bottom: 10px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .norm-cards-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 8px;
            margin-bottom: 10px;
        }

        .norm-card {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            padding: 8px 4px;
            display: flex;
            flex-direction: column;
            gap: 2px;
        }

        .norm-card .label {
            font-size: 0.60rem;
            color: #94a3b8;
            font-weight: 600;
            text-transform: uppercase;
        }

        .norm-card .value {
            font-size: 0.72rem;
            font-weight: 700;
            color: #0f172a;
            font-family: 'JetBrains Mono', monospace;
        }

        .norm-card.highlight .value {
            color: #d97706;
        }

        .legal-footer {
            font-size: 0.65rem;
            color: #94a3b8;
            line-height: 1.35;
        }
    </style>
</head>
<body>

<div class="auth-container">

    <!-- Top Server Status -->
    <div class="system-status-bar">
        <div>
            <i class="bi bi-hdd-network text-teal-600"></i>
            <span class="ms-1 fw-bold">Servidor Analítico Activo</span>
            <span class="text-muted ms-1">v3.4.2</span>
        </div>
        <div class="status-badge">LIMS ONLINE</div>
    </div>

    <div class="calibration-chip">
        <i class="bi bi-thermometer-half"></i> Espectrofotometría / Rancimat calibrado a <strong>120.0°C ± 0.1°</strong>
    </div>

    <!-- Main Login Card -->
    <div class="auth-card">
        <div class="brand-logo-wrap">
            <div class="brand-icon">
                <i class="bi bi-moisture"></i>
            </div>
            <div class="