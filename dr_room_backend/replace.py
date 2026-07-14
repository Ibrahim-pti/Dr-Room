import re

with open('resources/views/welcome.blade.php', 'r') as f:
    content = f.read()

replacements = {
    '>Home<': '>{{ __(\'landing.home\') }}<',
    '>Services<': '>{{ __(\'landing.services\') }}<',
    '>How It Works<': '>{{ __(\'landing.how_it_works\') }}<',
    '>About Us<': '>{{ __(\'landing.about_us\') }}<',
    '>FAQ<': '>{{ __(\'landing.faq\') }}<',
    '>Contact<': '>{{ __(\'landing.contact\') }}<',
    '>Download App<': '>{{ __(\'landing.download_app\') }}<',
    '>Language<': '>{{ __(\'landing.language\') }}<',
    'Healthcare at your doorstep</p>': '{{ __(\'landing.subtitle\') }}</p>',
    'Professional<br/>': '{{ __(\'landing.hero_title_1\') }}<br/>',
    ' Healthcare<br/>': ' {{ __(\'landing.hero_title_2\') }}<br/>',
    '>At Your Doorstep<': '>{{ __(\'landing.hero_title_3\') }}<',
    'DrRoom connects you with trusted healthcare services at home. Fast, easy and reliable.': '{{ __(\'landing.hero_desc\') }}',
    '>Download for<': '>{{ __(\'landing.download_android\') }}<',
    '>Android<': '>{{ __(\'landing.android\') }}<',
    '>iOS<': '>{{ __(\'landing.ios\') }}<',
    '>Happy Users<': '>{{ __(\'landing.happy_users\') }}<',
    '>Our Healthcare Services<': '>{{ __(\'landing.our_services\') }}<',
    '>Comprehensive healthcare services at your home<': '>{{ __(\'landing.services_desc\') }}<',
    '>Lab Tests<': '>{{ __(\'landing.lab_tests\') }}<',
    '>Home sample collection & lab tests<': '>{{ __(\'landing.lab_desc\') }}<',
    '>Available<': '>{{ __(\'landing.available\') }}<',
    '>Nursing<': '>{{ __(\'landing.nursing\') }}<',
    '>Professional nursing care at home<': '>{{ __(\'landing.nursing_desc\') }}<',
    '>Doctor<': '>{{ __(\'landing.doctor\') }}<',
    '>Online consultation & booking<': '>{{ __(\'landing.doctor_desc\') }}<',
    '>Coming Soon<': '>{{ __(\'landing.coming_soon\') }}<',
    '>Pharmacy<': '>{{ __(\'landing.pharmacy\') }}<',
    '>Medicine delivery to your home<': '>{{ __(\'landing.pharmacy_desc\') }}<',
    '>X-Ray<': '>{{ __(\'landing.xray\') }}<',
    '>X-ray & ultrasound at home or booking<': '>{{ __(\'landing.xray_desc\') }}<',
    '>More Services<': '>{{ __(\'landing.more_services\') }}<',
    '>Health check-up, fitness, diabetes care & more<': '>{{ __(\'landing.more_desc\') }}<',
    '>About DrRoom<': '>{{ __(\'landing.about_tag\') }}<',
    '>Quality Care You<br/>': '>{{ __(\'landing.quality_care\') }}<br/>',
    '>Can <': '>{{ __(\'landing.can_trust\') }} <', # This is Can <span...>Trust</span>
    'Trust</span>': '</span>',
    'DrRoom is a smart healthcare platform that brings medical services to your doorstep. Our verified professionals are ready to provide you and your family with the best care.': '{{ __(\'landing.about_desc\') }}',
    '>Verified Professionals<': '>{{ __(\'landing.verified_prof\') }}<',
    '>All our doctors and nurses are verified and experienced.<': '>{{ __(\'landing.verified_desc\') }}<',
    '>Fast & Reliable<': '>{{ __(\'landing.fast_reliable\') }}<',
    '>Quick response and on-time service at your location.<': '>{{ __(\'landing.fast_desc\') }}<',
    '>Easy Booking<': '>{{ __(\'landing.easy_booking\') }}<',
    '>Book your service in a few simple steps.<': '>{{ __(\'landing.easy_desc\') }}<',
    '>Secure Payments<': '>{{ __(\'landing.secure_pay\') }}<',
    '>100% secure and safe payment methods.<': '>{{ __(\'landing.secure_desc\') }}<',
    '>Services Completed<': '>{{ __(\'landing.services_completed\') }}<',
    '>Download DrRoom App<': '>{{ __(\'landing.download_drroom\') }}<',
    '>Get the best healthcare experience on your mobile device.<': '>{{ __(\'landing.get_best_exp\') }}<',
    '>GET IT ON<': '>{{ __(\'landing.get_on\') }}<',
    '>Google Play<': '>{{ __(\'landing.google_play\') }}<',
    '>Download on the<': '>{{ __(\'landing.download_on\') }}<',
    '>App Store<': '>{{ __(\'landing.app_store\') }}<',
    '>Three simple steps to get the healthcare you need<': '>{{ __(\'landing.how_works_desc\') }}<',
    '>Get our app from the App Store or Google Play and create your account.<': '>{{ __(\'landing.step_1_desc\') }}<',
    '>Choose Service<': '>{{ __(\'landing.step_2\') }}<',
    '>Select the healthcare service you need and book an appointment.<': '>{{ __(\'landing.step_2_desc\') }}<',
    '>Get Care<': '>{{ __(\'landing.step_3\') }}<',
    '>Our professional will arrive at your doorstep to provide care.<': '>{{ __(\'landing.step_3_desc\') }}<',
    '>Frequently Asked Questions<': '>{{ __(\'landing.faq_title\') }}<',
    '>Got questions? We\\\'ve got answers.<': '>{{ __(\'landing.faq_desc\') }}<',
    '>How do I book a service?<': '>{{ __(\'landing.faq_1_q\') }}<',
    '>You can easily book any healthcare service through our mobile app by selecting the service, choosing your preferred time, and confirming your location.<': '>{{ __(\'landing.faq_1_a\') }}<',
    '>Are the doctors and nurses certified?<': '>{{ __(\'landing.faq_2_q\') }}<',
    '>Yes, absolutely. All our healthcare professionals go through a strict background check and are fully certified, licensed, and experienced.<': '>{{ __(\'landing.faq_2_a\') }}<',
    '>What payment methods do you accept?<': '>{{ __(\'landing.faq_3_q\') }}<',
    '>We accept all major credit cards, mobile payments (like ZainCash and FastPay), and cash on delivery for certain services.<': '>{{ __(\'landing.faq_3_a\') }}<',
    '>What Our Users Say<': '>{{ __(\'landing.testimonials\') }}<',
    '>Real reviews from our happy customers<': '>{{ __(\'landing.test_desc\') }}<',
    '>"The nurse arrived on time and was very professional. Great service!"<': '>{{ __(\'landing.test_1\') }}<',
    '>"Very easy to use app. Lab test at home saved me a lot of time."<': '>{{ __(\'landing.test_2\') }}<',
    '>"Great experience with DrRoom. Highly recommended!"<': '>{{ __(\'landing.test_3\') }}<',
    'DrRoom is dedicated to providing high-quality healthcare services at your home with trust and care.': '{{ __(\'landing.footer_desc\') }}',
    '>Quick Links<': '>{{ __(\'landing.quick_links\') }}<',
    '>Support<': '>{{ __(\'landing.support\') }}<',
    '>Privacy Policy<': '>{{ __(\'landing.privacy\') }}<',
    '>Terms & Conditions<': '>{{ __(\'landing.terms\') }}<',
    '>Help Center<': '>{{ __(\'landing.help\') }}<',
    '>Contact Us<': '>{{ __(\'landing.contact_us\') }}<',
}

# Apply HTML and logic changes
content = content.replace('<html lang="en" dir="ltr" class="scroll-smooth">', '<html lang="{{ app()->getLocale() }}" dir="{{ in_array(app()->getLocale(), [\'ar\', \'ckb\']) ? \'rtl\' : \'ltr\' }}" class="scroll-smooth">')

# Replace the language switch links
content = content.replace('<a href="#" class="block px-4 py-2 text-sm text-blue-600 bg-blue-50 font-medium">English</a>', '<a href="/en" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-50 hover:text-blue-600 transition">English</a>')
content = content.replace('<a href="#" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-50 hover:text-blue-600 transition">کوردی</a>', '<a href="/ckb" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-50 hover:text-blue-600 transition">کوردی</a>')
content = content.replace('<a href="#" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-50 hover:text-blue-600 transition">العربية</a>', '<a href="/ar" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-50 hover:text-blue-600 transition">العربية</a>')

# Update the display of the current language button
content = content.replace('<span>EN</span>', '<span>{{ strtoupper(app()->getLocale() == "ckb" ? "KU" : app()->getLocale()) }}</span>')

# Mobile links
content = content.replace('<button class="flex-1 bg-blue-50 text-blue-600 py-2 rounded-lg text-sm font-medium border border-blue-100">EN</button>', '<a href="/en" class="flex-1 bg-gray-50 text-gray-600 hover:bg-gray-100 text-center block py-2 rounded-lg text-sm font-medium transition border border-transparent">EN</a>')
content = content.replace('<button class="flex-1 bg-gray-50 text-gray-600 hover:bg-gray-100 py-2 rounded-lg text-sm font-medium transition border border-transparent">کوردی</button>', '<a href="/ckb" class="flex-1 bg-gray-50 text-gray-600 hover:bg-gray-100 text-center block py-2 rounded-lg text-sm font-medium transition border border-transparent">کوردی</a>')
content = content.replace('<button class="flex-1 bg-gray-50 text-gray-600 hover:bg-gray-100 py-2 rounded-lg text-sm font-medium transition border border-transparent">عربي</button>', '<a href="/ar" class="flex-1 bg-gray-50 text-gray-600 hover:bg-gray-100 text-center block py-2 rounded-lg text-sm font-medium transition border border-transparent">عربي</a>')

for old, new in replacements.items():
    content = content.replace(old, new)

with open('resources/views/welcome.blade.php', 'w') as f:
    f.write(content)
