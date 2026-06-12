import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppTranslations extends Translations {
  static const String fallbackLocaleCode = 'en';
  static const Locale fallbackLocale = Locale(fallbackLocaleCode);

  static const Map<String, String> _en = {
    'app.title': 'SAFE',
    'common.save': 'Save',
    'common.cancel': 'Cancel',
    'common.delete': 'Delete',
    'common.retry': 'Retry',
    'common.next': 'Next',
    'common.skip': 'Skip',
    'nav.home': 'Home',
    'nav.chat': 'Chat',
    'nav.checklist': 'Checklist',
    'nav.history': 'History',
    'nav.safetyTips': 'Guides',
    'language.title': 'Choose Language',
    'language.profileTitle': 'Language',
    'language.onboardingTitle': 'Select Language',
    'language.onboardingSubtitle': 'Choose your preferred language',
    'language.english': 'English',
    'language.englishRegion': 'United Kingdom',
    'language.italian': 'Italian',
    'language.italianRegion': 'Italia',
    'language.saveContinue': 'Save and Continue',
    'language.saving': 'Saving...',
    'language.saved': 'Saved',
    'language.saveFailed': 'Save failed',
    'language.updated': 'Language updated successfully.',
    'language.updateFailed': 'Language updated locally. Backend sync failed.',
    'auth.loginEmail': 'User Email',
    'auth.loginEmailHint': 'Enter your email',
    'auth.password': 'Password',
    'auth.passwordHint': 'Enter your password',
    'auth.forgotPassword': 'Forgot password?',
    'auth.signIn': 'Sign in',
    'auth.signingIn': 'Signing in...',
    'auth.signedIn': 'Signed in',
    'auth.signInFailed': 'Sign in failed',
    'auth.noAccount': 'Don\'t have an account?',
    'auth.signUpHere': 'Sign Up Here',
    'auth.continueGoogle': 'Continue with Google',
    'auth.continueFacebook': 'Continue with Facebook',
    'auth.pleaseEnterEmail': 'Please enter your email',
    'auth.invalidEmail': 'Please enter a valid email',
    'auth.pleaseEnterPassword': 'Please enter your password',
    'auth.passwordMin': 'Password must be at least 6 characters',
    'auth.signupHero': 'Let\'s Get Started!',
    'auth.createAccount': 'Create an account',
    'auth.userName': 'Full Name',
    'auth.userNameHint': 'Enter your full name',
    'auth.enterName': 'Enter your name',
    'auth.yourEmail': 'Your Email',
    'auth.phoneNumber': 'Phone Number',
    'auth.phoneNumberHint': 'Enter your phone number',
    'auth.enterPhoneNumber': 'Enter your phone number',
    'auth.confirmPassword': 'Confirm Password',
    'auth.confirmPasswordHint': 'Enter confirm password',
    'auth.enterPassword': 'Enter password',
    'auth.confirmYourPassword': 'Confirm your password',
    'auth.passwordsDoNotMatch': 'Passwords do not match',
    'auth.minimumSixCharacters': 'Minimum 6 characters',
    'auth.signUp': 'Sign up',
    'auth.creatingAccount': 'Creating account...',
    'auth.accountCreated': 'Account created',
    'auth.signupFailed': 'Signup failed',
    'auth.haveAccount': 'Already have an account?',
    'auth.signInHere': 'Sign In Here',
    'onboarding.skip': 'Skip',
    'onboarding.next': 'Next',
    'onboarding.getStarted': 'Get Started',
    'onboarding.page1Title': 'A calm space to Think, Talk & Feel Better',
    'onboarding.page1Body':
        'AI Chat is designed to support you during stressful moments, emotional overwhelm, or when life simply feels too heavy.',
    'onboarding.page2Title': 'Support when life feels overwhelming',
    'onboarding.page2Body':
        'Whether you\'re stressed, mentally overloaded, or just need someone to talk to, we\'re here for you.',
    'onboarding.page3Title': 'Designed for Calm & Accessibility',
    'onboarding.page3Body':
        'Everyone deserves support that feels simple, comfortable, and easy to use.',
    'onboarding.emergencyTitle': 'Emergency help, when you need it',
    'onboarding.emergencyBody':
        'SAFE gives you instant, reliable guidance for fires, earthquakes, blackouts, and first aid when every second counts.',
    'onboarding.languageTitle': 'Multi-language Support',
    'onboarding.languageBody':
        'Access critical information in English or Italian. Instructions stay clear and accessible for everyone.',
    'onboarding.keyFeature': 'Key Feature',
    'onboarding.feature.aiTitle': 'AI Chat Support',
    'onboarding.feature.aiBody': 'Instant answers powered by advanced AI',
    'onboarding.feature.guidesTitle': 'Safety Guides',
    'onboarding.feature.guidesBody': 'First aid and emergency instructions',
    'onboarding.feature.historyTitle': 'Chat History',
    'onboarding.feature.historyBody': 'All conversations saved and accessible',
    'onboarding.feature.languageTitle': 'Language Preference',
    'onboarding.feature.languageBody': 'Choose your preferred language',
    'onboarding.feature.checklistTitle': 'Checklist',
    'onboarding.feature.checklistBody':
        'Prepare emergency plans and essentials',
    'home.greeting': 'Hello, @name',
    'home.subtitle': 'How can I help you today?',
    'home.startChat': 'Start Chat',
    'home.startChatBody': 'Get instant AI emergency assistance now',
    'home.typeMessage': 'Type a message...',
    'home.emergencyType': 'Emergency type',
    'home.safetyTips': 'Guides',
    'home.viewAll': 'View all',
    'home.noSafetyTips': 'No guides available.',
    'home.loadSafetyTipFailed': 'Failed to load guide.',
    'home.essential': 'ESSENTIAL',
    'safetyTip.estimatedRead': '@minutes min read',
    'safetyTip.askAi': 'Ask AI for Help',
    'safetyTip.overview': 'Overview',
    'safetyTip.do': 'Do',
    'safetyTip.dont': 'Don\'t',
    'safetyTip.section': 'Section',
    'emergency.fire': 'Fire',
    'emergency.earthquake': 'Earthquake',
    'emergency.firstAid': 'First Aid',
    'emergency.blackout': 'Blackout',
    'emergency.general': 'General',
    'emergency.other': 'Other',
    'emergency.generalPrompt': 'I need general safety guidance.',
    'emergency.firePrompt':
        'There is a fire emergency at home. What should I do first?',
    'emergency.earthquakePrompt':
        'There is an earthquake. What should I do first at home?',
    'emergency.firstAidPrompt':
        'I need first aid help at home. What should I do first?',
    'emergency.blackoutPrompt':
        'There is a blackout at home. What should I do first?',
    'profile.editProfile': 'Edit Profile',
    'profile.changePassword': 'Change Password',
    'profile.aboutApp': 'About App',
    'profile.privacyPolicy': 'Privacy Policy',
    'profile.termsConditions': 'Terms & Conditions',
    'profile.language': 'Language',
    'profile.pushNotifications': 'Push Notifications',
    'profile.logout': 'Log Out',
    'history.title': 'Chat History',
    'history.searchHint': 'Search here...',
    'history.noHistory': 'No chat history available.',
    'history.noMatch': 'No matching chat history found.',
    'history.invalidConversation': 'Invalid conversation ID.',
    'history.loadConversationFailed': 'Failed to load conversation.',
    'history.deleteTitle': 'Delete conversation',
    'history.deleteConfirm': 'Are you sure you want to delete "@title"?',
    'history.deleteFallbackTitle': 'this conversation',
    'history.deleteFailed': 'Failed to delete conversation.',
    'history.deleteSuccess': 'Conversation deleted successfully.',
    'history.untitled': 'Untitled chat',
    'history.noPreview': 'No message preview.',
    'history.messageCount': '@count messages',
    'history.today': 'Today',
    'history.yesterday': 'Yesterday',
    'chat.title': 'Emergency Chat',
    'chat.deliveryUnavailable':
        'Emergency guidance is temporarily unavailable. Please tap Retry or try again shortly.',
    'chat.welcomeGeneral':
        'Hello 👋\n'
        'I\'m WeSafe AI, your assistant for safety, emergencies, and preparedness.\n\n'
        'I can help you with:\n\n'
        '* 🚨 Blackouts, fires, earthquakes, and floods\n'
        '* 🧰 72h kits, home kits, and checklists\n'
        '* 🩹 Basic first aid\n'
        '* 🛡️ Practical safety advice\n\n'
        'Examples:\n'
        '👉 “What should I do during a blackout?”\n'
        '👉 “What should I put in a 72h kit?”\n\n'
        'Being prepared today can make a difference tomorrow.\n'
        'Where would you like to start?',
    'chat.welcomeFire':
        'Hello 👋\n'
        'I can help you with fire safety and emergency steps.\n\n'
        'I can support you with:\n\n'
        '* 🔥 What to do if a fire starts\n'
        '* 🚪 Safe evacuation steps\n'
        '* ☎️ When to call emergency services\n'
        '* 🧯 Practical fire prevention advice\n\n'
        'Examples:\n'
        '👉 “What should I do if there is a fire in my kitchen?”\n'
        '👉 “How do I evacuate safely?”\n\n'
        'Where would you like to start?',
    'chat.welcomeFirstAid':
        'Hello 👋\n'
        'I can help you with basic first aid guidance.\n\n'
        'I can support you with:\n\n'
        '* 🩹 First steps before help arrives\n'
        '* 🩸 Minor cuts, burns, and bleeding\n'
        '* 🤕 Safe actions to avoid making things worse\n'
        '* 📋 Clear, practical first aid advice\n\n'
        'Examples:\n'
        '👉 “What should I do first for a burn?”\n'
        '👉 “How do I stop bleeding safely?”\n\n'
        'Where would you like to start?',
    'chat.welcomeEarthquake':
        'Hello 👋\n'
        'I can help you stay safer during and after an earthquake.\n\n'
        'I can support you with:\n\n'
        '* 🌍 What to do during shaking\n'
        '* 🏠 Safer actions indoors and outdoors\n'
        '* ⚠️ What to check after the earthquake\n'
        '* 🎒 Preparedness and emergency kit advice\n\n'
        'Examples:\n'
        '👉 “What should I do during an earthquake?”\n'
        '👉 “Is it safer to go outside right away?”\n\n'
        'Where would you like to start?',
    'chat.welcomeBlackout':
        'Hello 👋\n'
        'I can help you stay safe during a blackout.\n\n'
        'I can support you with:\n\n'
        '* 🔦 Safe lighting and power outage steps\n'
        '* 🧊 Food, water, and fridge safety\n'
        '* 📱 Phone charging and communication tips\n'
        '* 🏠 Home preparedness during extended outages\n\n'
        'Examples:\n'
        '👉 “What should I do during a blackout?”\n'
        '👉 “How long is food safe in the fridge?”\n\n'
        'Where would you like to start?',
    'chat.selectedIntro':
        'You selected @topic. Send a message and I will provide step-by-step emergency guidance.',
    'chat.quick.fire.one': 'Help with a fire emergency',
    'chat.quick.fire.two': 'How do I evacuate safely?',
    'chat.quick.general.one': 'I need general safety advice',
    'chat.quick.general.two': 'How can I prepare for emergencies?',
    'chat.quick.firstAid.one': 'Need first aid help',
    'chat.quick.firstAid.two': 'What should I do first?',
    'chat.quick.earthquake.one': 'Help with an earthquake',
    'chat.quick.earthquake.two': 'What should I do now?',
    'chat.quick.blackout.one': 'There is a power outage at home',
    'chat.quick.blackout.two': 'How do I stay safe during blackout?',
    'checklist.addNew': 'Add new',
    'checklist.noItems': 'No checklist available.',
    'checklist.deleteTitle': 'Delete checklist',
    'checklist.deleteConfirm': 'Are you sure you want to delete "@title"?',
    'checklist.deleteFallbackTitle': 'this checklist',
    'checklist.deleteSuccess': 'Checklist deleted successfully.',
    'checklist.deleteFailed': 'Failed to delete checklist.',
    'checklist.idMissing': 'Checklist id is missing.',
    'checklist.detailsNotFound': 'Checklist details not found.',
    'checklist.completed': 'Completed',
    'checklist.fileSizeLimit': 'File size must be 10MB or less.',
    'checklist.enterName': 'Please enter checklist name.',
    'checklist.enterCategory': 'Please enter category.',
    'checklist.enterDescription': 'Please enter description.',
    'checklist.addItemRequired': 'Please add at least one checklist item.',
    'checklist.name': 'Checklist Name',
    'checklist.category': 'Category',
    'checklist.fireSafetyHint': 'Fire Safety',
    'checklist.description': 'Description',
    'checklist.descriptionHint': 'Write a short checklist description',
    'checklist.uploadIcon': 'Upload Icon',
    'checklist.addMore': 'Add more',
    'checklist.update': 'Update',
    'checklist.updating': 'Updating...',
    'checklist.updated': 'Updated',
    'checklist.updateFailed': 'Update failed',
    'checklist.editTitle': 'Edit checklist',
    'checklist.addTitle': 'Add new checklist',
    'checklist.templateEditNote':
        'You are editing a default checklist. Your changes will be saved to your own personal copy only.',
    'checklist.currentImage': 'Current image',
    'checklist.changeImage': 'Change image',
    'checklist.remove': 'Remove',
    'checklist.upload': 'upload',
    'checklist.uploadLimit': 'PNG,JPG,GIF up to 10MB',
    'checklist.previewError': 'Unable to preview image',
    'checklist.addItem': 'Add Item',
    'checklist.itemHint': 'Keep emergency kit accessible',
    'notification.title': 'Notifications',
    'notification.none': 'No notifications available.',
    'notification.readAll': 'Read All',
    'common.error': 'Error',
    'common.user': 'User',
    'message.guidance': 'EMERGENCY GUIDANCE',
    'message.copied': 'Message copied',
    'message.copy': 'Copy',
    'profile.userName': 'User Name',
    'profile.enterName': 'Enter your name',
    'profile.nameRequired': 'User name is required',
    'profile.currentPassword': 'Current Password',
    'profile.enterCurrentPassword': 'Please enter your current password',
    'profile.newPassword': 'New Password',
    'profile.enterNewPassword': 'Please enter new password',
    'profile.passwordMin': 'Password must be at least 6 characters',
    'profile.confirmNewPassword': 'Confirm New Password',
    'profile.confirmPassword': 'Please confirm your password',
    'profile.passwordsNotMatch': 'Passwords do not match',
    'profile.logoutConfirm': 'Are you sure to log out?',
    'profile.deleteAccount': 'Delete Account',
    'profile.deleteAccountConfirm':
        'Are you sure you want to delete your account? This action is permanent and cannot be undone.',
  };

  static const Map<String, String> _it = {
    'app.title': 'SAFE',
    'common.save': 'Salva',
    'common.cancel': 'Annulla',
    'common.delete': 'Elimina',
    'common.retry': 'Riprova',
    'common.next': 'Avanti',
    'common.skip': 'Salta',
    'nav.home': 'Home',
    'nav.chat': 'Chat',
    'nav.checklist': 'Checklist',
    'nav.history': 'Cronologia',
    'nav.safetyTips': 'Guide',
    'language.title': 'Scegli lingua',
    'language.profileTitle': 'Lingua',
    'language.onboardingTitle': 'Seleziona lingua',
    'language.onboardingSubtitle': 'Scegli la tua lingua preferita',
    'language.english': 'Inglese',
    'language.englishRegion': 'Regno Unito',
    'language.italian': 'Italiano',
    'language.italianRegion': 'Italia',
    'language.saveContinue': 'Salva e continua',
    'language.saving': 'Salvataggio...',
    'language.saved': 'Salvato',
    'language.saveFailed': 'Salvataggio non riuscito',
    'language.updated': 'Lingua aggiornata con successo.',
    'language.updateFailed':
        'Lingua aggiornata sul dispositivo. Sincronizzazione backend non riuscita.',
    'auth.loginEmail': 'Email utente',
    'auth.loginEmailHint': 'Inserisci la tua email',
    'auth.password': 'Password',
    'auth.passwordHint': 'Inserisci la tua password',
    'auth.forgotPassword': 'Password dimenticata?',
    'auth.signIn': 'Accedi',
    'auth.signingIn': 'Accesso in corso...',
    'auth.signedIn': 'Accesso effettuato',
    'auth.signInFailed': 'Accesso non riuscito',
    'auth.noAccount': 'Non hai un account?',
    'auth.signUpHere': 'Registrati qui',
    'auth.continueGoogle': 'Continua con Google',
    'auth.continueFacebook': 'Continua con Facebook',
    'auth.pleaseEnterEmail': 'Inserisci la tua email',
    'auth.invalidEmail': 'Inserisci un indirizzo email valido',
    'auth.pleaseEnterPassword': 'Inserisci la tua password',
    'auth.passwordMin': 'La password deve contenere almeno 6 caratteri',
    'auth.signupHero': 'Iniziamo!',
    'auth.createAccount': 'Crea un account',
    'auth.userName': 'Nome completo',
    'auth.userNameHint': 'Inserisci il tuo nome completo',
    'auth.enterName': 'Inserisci il tuo nome',
    'auth.yourEmail': 'La tua email',
    'auth.phoneNumber': 'Numero di telefono',
    'auth.phoneNumberHint': 'Inserisci il tuo numero di telefono',
    'auth.enterPhoneNumber': 'Inserisci il tuo numero di telefono',
    'auth.confirmPassword': 'Conferma password',
    'auth.confirmPasswordHint': 'Conferma la password',
    'auth.enterPassword': 'Inserisci la password',
    'auth.confirmYourPassword': 'Conferma la tua password',
    'auth.passwordsDoNotMatch': 'Le password non corrispondono',
    'auth.minimumSixCharacters': 'Minimo 6 caratteri',
    'auth.signUp': 'Registrati',
    'auth.creatingAccount': 'Creazione account...',
    'auth.accountCreated': 'Account creato',
    'auth.signupFailed': 'Registrazione non riuscita',
    'auth.haveAccount': 'Hai già un account?',
    'auth.signInHere': 'Accedi qui',
    'onboarding.skip': 'Salta',
    'onboarding.next': 'Avanti',
    'onboarding.getStarted': 'Inizia',
    'onboarding.page1Title':
        'Uno spazio tranquillo per Pensare, Parlare e Stare Meglio',
    'onboarding.page1Body':
        'La nostra AI Chat è progettata per supportarti durante momenti di stress, sovraccarico emotivo o quando la vita sembra troppo pesante.',
    'onboarding.page2Title': 'Supporto quando la vita si fa opprimente',
    'onboarding.page2Body':
        'Che tu sia stressato, mentalmente sovraccarico, o abbia solo bisogno di qualcuno con cui parlare, siamo qui per te.',
    'onboarding.page3Title': 'Progettato per la Calma e l\'Accessibilità',
    'onboarding.page3Body':
        'Tutti meritano un supporto che si senta semplice, confortevole e facile da usare.',
    'onboarding.emergencyTitle': 'Aiuto nelle emergenze, quando ne hai bisogno',
    'onboarding.emergencyBody':
        'SAFE ti offre indicazioni immediate e affidabili per incendi, terremoti, blackout e primo soccorso quando ogni secondo conta.',
    'onboarding.languageTitle': 'Supporto multilingua',
    'onboarding.languageBody':
        'Accedi alle informazioni critiche in inglese o in italiano. Le istruzioni restano chiare e accessibili per tutti.',
    'onboarding.keyFeature': 'Funzionalità principali',
    'onboarding.feature.aiTitle': 'Supporto chat AI',
    'onboarding.feature.aiBody':
        'Risposte immediate grazie all\'intelligenza artificiale',
    'onboarding.feature.guidesTitle': 'Guide di sicurezza',
    'onboarding.feature.guidesBody':
        'Istruzioni di primo soccorso e per le emergenze',
    'onboarding.feature.historyTitle': 'Cronologia chat',
    'onboarding.feature.historyBody':
        'Tutte le conversazioni salvate e accessibili',
    'onboarding.feature.languageTitle': 'Preferenza lingua',
    'onboarding.feature.languageBody': 'Scegli la tua lingua preferita',
    'onboarding.feature.checklistTitle': 'Checklist',
    'onboarding.feature.checklistBody':
        'Prepara piani di emergenza e materiali essenziali',
    'home.greeting': 'Ciao, @name',
    'home.subtitle': 'Come posso aiutarti oggi?',
    'home.startChat': 'Avvia chat',
    'home.startChatBody': 'Ricevi subito assistenza AI per le emergenze',
    'home.typeMessage': 'Scrivi un messaggio...',
    'home.emergencyType': 'Tipo di emergenza',
    'home.safetyTips': 'Guide',
    'home.viewAll': 'Vedi tutto',
    'home.noSafetyTips': 'Nessuna guida disponibile.',
    'home.loadSafetyTipFailed': 'Impossibile caricare la guida.',
    'home.essential': 'ESSENZIALE',
    'safetyTip.estimatedRead': '@minutes min di lettura',
    'safetyTip.askAi': 'Chiedi aiuto all\'IA',
    'safetyTip.overview': 'Panoramica',
    'safetyTip.do': 'Cosa fare',
    'safetyTip.dont': 'Cosa non fare',
    'safetyTip.section': 'Sezione',
    'emergency.fire': 'Incendio',
    'emergency.earthquake': 'Terremoto',
    'emergency.firstAid': 'Primo soccorso',
    'emergency.blackout': 'Blackout',
    'emergency.general': 'Generale',
    'emergency.other': 'Altro',
    'emergency.generalPrompt':
        'Ho bisogno di indicazioni generali sulla sicurezza.',
    'emergency.firePrompt':
        'C\'è un incendio in casa. Cosa devo fare per prima cosa?',
    'emergency.earthquakePrompt':
        'C\'è un terremoto. Cosa devo fare subito a casa?',
    'emergency.firstAidPrompt':
        'Ho bisogno di aiuto di primo soccorso a casa. Cosa devo fare per prima cosa?',
    'emergency.blackoutPrompt':
        'C\'è un blackout in casa. Cosa devo fare per prima cosa?',
    'profile.editProfile': 'Modifica profilo',
    'profile.changePassword': 'Cambia password',
    'profile.aboutApp': 'Informazioni sull\'app',
    'profile.privacyPolicy': 'Privacy policy',
    'profile.termsConditions': 'Termini e condizioni',
    'profile.language': 'Lingua',
    'profile.pushNotifications': 'Notifiche push',
    'profile.logout': 'Esci',
    'history.title': 'Cronologia chat',
    'history.searchHint': 'Cerca qui...',
    'history.noHistory': 'Nessuna cronologia chat disponibile.',
    'history.noMatch': 'Nessuna chat corrispondente trovata.',
    'history.invalidConversation': 'ID conversazione non valido.',
    'history.loadConversationFailed': 'Impossibile caricare la conversazione.',
    'history.deleteTitle': 'Elimina conversazione',
    'history.deleteConfirm': 'Vuoi davvero eliminare "@title"?',
    'history.deleteFallbackTitle': 'questa conversazione',
    'history.deleteFailed': 'Impossibile eliminare la conversazione.',
    'history.deleteSuccess': 'Conversazione eliminata con successo.',
    'history.untitled': 'Chat senza titolo',
    'history.noPreview': 'Nessuna anteprima disponibile.',
    'history.messageCount': '@count messaggi',
    'history.today': 'Oggi',
    'history.yesterday': 'Ieri',
    'chat.title': 'Chat emergenza',
    'chat.deliveryUnavailable':
        'La guida di emergenza non è temporaneamente disponibile. Tocca Riprova o riprova tra poco.',
    'chat.welcomeGeneral':
        'Ciao 👋\n'
        'Sono WeSafe AI, il tuo assistente dedicato a sicurezza, emergenze e preparazione.\n\n'
        'Posso aiutarti con:\n\n'
        '* 🚨 Blackout, incendi, terremoti e alluvioni\n'
        '* 🧰 Kit 72h, kit casa e checklist\n'
        '* 🩹 Primo soccorso base\n'
        '* 🛡️ Consigli pratici per ridurre i rischi\n\n'
        'Esempi:\n'
        '👉 “Cosa fare durante un blackout?”\n'
        '👉 “Cosa mettere in un kit 72h?”\n\n'
        'Prepararsi oggi può fare la differenza domani.\n'
        'Da dove vuoi iniziare?',
    'chat.welcomeFire':
        'Ciao 👋\n'
        'Posso aiutarti con la sicurezza antincendio e i passi da seguire in emergenza.\n\n'
        'Posso aiutarti con:\n\n'
        '* 🔥 Cosa fare se inizia un incendio\n'
        '* 🚪 Come evacuare in sicurezza\n'
        '* ☎️ Quando chiamare i servizi di emergenza\n'
        '* 🧯 Consigli pratici per prevenire incendi\n\n'
        'Esempi:\n'
        '👉 “Cosa devo fare se c\'è un incendio in cucina?”\n'
        '👉 “Come evacuo in sicurezza?”\n\n'
        'Da dove vuoi iniziare?',
    'chat.welcomeFirstAid':
        'Ciao 👋\n'
        'Posso aiutarti con indicazioni di primo soccorso di base.\n\n'
        'Posso aiutarti con:\n\n'
        '* 🩹 I primi passi prima che arrivi aiuto\n'
        '* 🩸 Tagli lievi, ustioni e sanguinamenti\n'
        '* 🤕 Azioni sicure per non peggiorare la situazione\n'
        '* 📋 Consigli chiari e pratici di primo soccorso\n\n'
        'Esempi:\n'
        '👉 “Cosa devo fare per prima cosa in caso di ustione?”\n'
        '👉 “Come fermo un sanguinamento in sicurezza?”\n\n'
        'Da dove vuoi iniziare?',
    'chat.welcomeEarthquake':
        'Ciao 👋\n'
        'Posso aiutarti a restare più al sicuro durante e dopo un terremoto.\n\n'
        'Posso aiutarti con:\n\n'
        '* 🌍 Cosa fare durante la scossa\n'
        '* 🏠 Azioni più sicure in casa e all\'aperto\n'
        '* ⚠️ Cosa controllare dopo il terremoto\n'
        '* 🎒 Preparazione e consigli sul kit di emergenza\n\n'
        'Esempi:\n'
        '👉 “Cosa devo fare durante un terremoto?”\n'
        '👉 “È più sicuro uscire subito?”\n\n'
        'Da dove vuoi iniziare?',
    'chat.welcomeBlackout':
        'Ciao 👋\n'
        'Posso aiutarti a restare al sicuro durante un blackout.\n\n'
        'Posso aiutarti con:\n\n'
        '* 🔦 Illuminazione sicura e passi da seguire senza corrente\n'
        '* 🧊 Sicurezza di cibo, acqua e frigorifero\n'
        '* 📱 Consigli per caricare il telefono e comunicare\n'
        '* 🏠 Preparazione della casa durante interruzioni prolungate\n\n'
        'Esempi:\n'
        '👉 “Cosa fare durante un blackout?”\n'
        '👉 “Per quanto tempo il cibo resta sicuro in frigo?”\n\n'
        'Da dove vuoi iniziare?',
    'chat.selectedIntro':
        'Hai selezionato @topic. Invia un messaggio e ti fornirò indicazioni di emergenza passo dopo passo.',
    'chat.quick.fire.one': 'Aiuto per un\'emergenza incendio',
    'chat.quick.fire.two': 'Come evacuo in sicurezza?',
    'chat.quick.general.one': 'Ho bisogno di consigli generali sulla sicurezza',
    'chat.quick.general.two': 'Come posso prepararmi alle emergenze?',
    'chat.quick.firstAid.one': 'Ho bisogno di primo soccorso',
    'chat.quick.firstAid.two': 'Cosa devo fare per prima cosa?',
    'chat.quick.earthquake.one': 'Aiuto per un terremoto',
    'chat.quick.earthquake.two': 'Cosa devo fare adesso?',
    'chat.quick.blackout.one': 'C\'è una mancanza di corrente in casa',
    'chat.quick.blackout.two': 'Come resto al sicuro durante il blackout?',
    'checklist.addNew': 'Aggiungi',
    'checklist.noItems': 'Nessuna checklist disponibile.',
    'checklist.deleteTitle': 'Elimina checklist',
    'checklist.deleteConfirm': 'Vuoi davvero eliminare "@title"?',
    'checklist.deleteFallbackTitle': 'questa checklist',
    'checklist.deleteSuccess': 'Checklist eliminata con successo.',
    'checklist.deleteFailed': 'Impossibile eliminare la checklist.',
    'checklist.idMissing': 'ID della checklist mancante.',
    'checklist.detailsNotFound': 'Dettagli della checklist non trovati.',
    'checklist.completed': 'Completato',
    'checklist.fileSizeLimit':
        'La dimensione del file deve essere di 10 MB o inferiore.',
    'checklist.enterName': 'Inserisci il nome della checklist.',
    'checklist.enterCategory': 'Inserisci la categoria.',
    'checklist.enterDescription': 'Inserisci la descrizione.',
    'checklist.addItemRequired': 'Aggiungi almeno un elemento alla checklist.',
    'checklist.name': 'Nome checklist',
    'checklist.category': 'Categoria',
    'checklist.fireSafetyHint': 'Sicurezza antincendio',
    'checklist.description': 'Descrizione',
    'checklist.descriptionHint': 'Scrivi una breve descrizione della checklist',
    'checklist.uploadIcon': 'Carica icona',
    'checklist.addMore': 'Aggiungi altro',
    'checklist.update': 'Aggiorna',
    'checklist.updating': 'Aggiornamento in corso...',
    'checklist.updated': 'Aggiornato',
    'checklist.updateFailed': 'Aggiornamento non riuscito',
    'checklist.editTitle': 'Modifica checklist',
    'checklist.addTitle': 'Aggiungi nuova checklist',
    'checklist.templateEditNote':
        'Stai modificando una checklist predefinita. Le tue modifiche verranno salvate solo nella tua copia personale.',
    'checklist.currentImage': 'Immagine corrente',
    'checklist.changeImage': 'Cambia immagine',
    'checklist.remove': 'Rimuovi',
    'checklist.upload': 'carica',
    'checklist.uploadLimit': 'PNG, JPG, GIF fino a 10MB',
    'checklist.previewError':
        'Impossibile visualizzare l\'anteprima dell\'immagine',
    'checklist.addItem': 'Aggiungi elemento',
    'checklist.itemHint': 'Mantieni il kit di emergenza accessibile',
    'notification.title': 'Notifiche',
    'notification.none': 'Nessuna notifica disponibile.',
    'notification.readAll': 'Segna tutte come lette',
    'common.error': 'Errore',
    'common.user': 'Utente',
    'message.guidance': 'GUIDA DI EMERGENZA',
    'message.copied': 'Messaggio copiato',
    'message.copy': 'Copia',
    'profile.userName': 'Nome utente',
    'profile.enterName': 'Inserisci il tuo nome',
    'profile.nameRequired': 'Il nome utente è obbligatorio',
    'profile.currentPassword': 'Password attuale',
    'profile.enterCurrentPassword': 'Inserisci la tua password attuale',
    'profile.newPassword': 'Nuova password',
    'profile.enterNewPassword': 'Inserisci la nuova password',
    'profile.passwordMin': 'La password deve contenere almeno 6 caratteri',
    'profile.confirmNewPassword': 'Conferma nuova password',
    'profile.confirmPassword': 'Conferma la tua password',
    'profile.passwordsNotMatch': 'Le password non corrispondono',
    'profile.logoutConfirm': 'Sei sicuro di voler uscire?',
    'profile.deleteAccount': 'Elimina account',
    'profile.deleteAccountConfirm':
        'Sei sicuro di voler eliminare il tuo account? Questa azione è permanente e non può essere annullata.',
  };

  @override
  Map<String, Map<String, String>> get keys => {
    'en_GB': _en,
    'en': _en,
    'it_IT': _it,
    'it': _it,
  };
}
