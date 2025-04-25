import 'package:azkary/features/azkar/data/azkar_evening.dart';
import 'package:azkary/features/azkar/data/azkar_morning.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/azkar_category.dart';
import '../../domain/entities/azkar.dart';

// Use this provider to get the list of Azkar categories
final azkarCategoriesProvider = Provider<List<AzkarCategory>>((ref) {
  return [
    const AzkarCategory(
      id: 'morning',
      name: 'Morning Azkar',
      nameAr: 'أذكار الصباح',
      icon: Icons.wb_sunny,
      azkarCount: 15,
      description: 'Morning remembrance and supplications',
    ),
    const AzkarCategory(
      id: 'evening', 
      name: 'Evening Azkar',
      nameAr: 'أذكار المساء',
      icon: Icons.nights_stay,
      azkarCount: 15,
      description: 'Evening remembrance and supplications',
    ),
    const AzkarCategory(
      id: 'sleep',
      name: 'Sleep Azkar', 
      nameAr: 'أذكار النوم',
      icon: Icons.bedtime,
      azkarCount: 15,
      description: 'Azkar before sleeping',
    ),
    const AzkarCategory(
      id: 'wake',
      name: 'Wake Up Azkar',
      nameAr: 'أذكار الاستيقاظ', 
      icon: Icons.alarm,
      azkarCount: 15,
      description: 'Azkar after waking up',
    ),
    const AzkarCategory(
      id: 'prayer',
      name: 'After Prayer',
      nameAr: 'أذكار بعد الصلاة',
      icon: Icons.mosque,
      azkarCount: 15,
      description: 'Azkar after completing prayer',
    ),
    const AzkarCategory(
      id: 'quran',
      name: 'Quranic Duas',
      nameAr: 'أدعية قرآنية',
      icon: Icons.book,
      azkarCount: 15,
      description: 'Supplications from the Holy Quran',
    ),
  ];
});

// Use this provider to track the currently selected category
final selectedCategoryProvider = StateProvider<AzkarCategory?>((ref) => null);

// Use this provider to get Azkar list for a specific category
// Example: final azkarList = ref.watch(azkarByCategoryProvider('morning'));
final  azkarByCategoryProvider = Provider.family<List<Azkar>, String>((ref, categoryId) {
  switch (categoryId) {
    case 'morning':
      return morningAzkar;
    case 'evening':
      return eveningAzkar;
    case 'sleep':
      return [
        const Azkar(
          id: 'sleep_1',
          arabicText: 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
          translation: 'In Your name, O Allah, I die and I live',
          reference: 'البخاري ١١:١١٣',
          repeatCount: 1,
          virtue: 10,
        ),
        const Azkar(
          id: 'sleep_2',
          arabicText: 'اللَّهُمَّ قِنِي عَذَابَكَ يَوْمَ تَبْعَثُ عِبَادَكَ',
          translation: 'O Allah, protect me from Your punishment on the day You resurrect Your servants',
          reference: 'أبو داود ٤:٣١١',
          repeatCount: 3,
          virtue: 10,
        ),
        const Azkar(
          id: 'sleep_3',
          arabicText: 'سُبْحَانَ اللَّهِ',
          translation: 'Glory be to Allah',
          reference: 'البخاري ٨:٤٤٤',
          repeatCount: 33,
          virtue: 10,
        ),
        const Azkar(
          id: 'sleep_4', 
          arabicText: 'الْحَمْدُ لِلَّهِ',
          translation: 'All praise is for Allah',
          reference: 'البخاري ٨:٤٤٤',
          repeatCount: 33,
          virtue: 10,
        ),
        const Azkar(
          id: 'sleep_5',
          arabicText: 'اللَّهُ أَكْبَرُ',
          translation: 'Allah is the Greatest',
          reference: 'البخاري ٨:٤٤٤',
          repeatCount: 34,
          virtue: 10,
        ),
        const Azkar(
          id: 'sleep_6',
          arabicText: 'اللَّهُمَّ إِنَّكَ خَلَقْتَ نَفْسِي وَأَنْتَ تَوَفَّاهَا، لَكَ مَمَاتُهَا وَمَحْيَاهَا، إِنْ أَحْيَيْتَهَا فَاحْفَظْهَا، وَإِنْ أَمَتَّهَا فَاغْفِرْ لَهَا',
          translation: 'O Allah, You created my soul and You take it back. Unto You is its death and its life. If You give it life then protect it, and if You cause it to die then forgive it',
          reference: 'مسلم ٤:٢٠٨٣',
          repeatCount: 1,
          virtue: 10,
        ),
        const Azkar(
          id: 'sleep_7',
          arabicText: 'بِاسْمِكَ رَبِّي وَضَعْتُ جَنْبِي، وَبِكَ أَرْفَعُهُ، فَإِنْ أَمْسَكْتَ نَفْسِي فَارْحَمْهَا، وَإِنْ أَرْسَلْتَهَا فَاحْفَظْهَا بِمَا تَحْفَظُ بِهِ عِبَادَكَ الصَّالِحِينَ',
          translation: 'In Your name my Lord, I lie down and in Your name I rise, so if You take my soul then have mercy upon it, and if You release it then protect it with that which You protect Your righteous servants',
          reference: 'البخاري ١١:١٢٦',
          repeatCount: 1,
          virtue: 10,
        ),
        const Azkar(
          id: 'sleep_8',
          arabicText: 'اللَّهُمَّ أَسْلَمْتُ نَفْسِي إِلَيْكَ، وَفَوَّضْتُ أَمْرِي إِلَيْكَ، وَوَجَّهْتُ وَجْهِي إِلَيْكَ، وَأَلْجَأْتُ ظَهْرِي إِلَيْكَ',
          translation: 'O Allah, I submit myself to You, entrust my affairs to You, turn my face to You, and lay myself down depending upon You',
          reference: 'البخاري ٨:٢٧٤',
          repeatCount: 1,
          virtue: 10,
        ),
        const Azkar(
          id: 'sleep_9',
          arabicText: 'اللَّهُمَّ قِنِي عَذَابَكَ يَوْمَ تَبْعَثُ عِبَادَكَ',
          translation: 'O Allah, save me from Your punishment on the Day You resurrect Your servants',
          reference: 'أبو داود ٤:٣١١',
          repeatCount: 3,
          virtue: 10,
        ),
        const Azkar(
          id: 'sleep_10',
          arabicText: 'آمَنتُ بِكِتَابِكَ الَّذِي أَنزَلْتَ وَنَبِيِّكَ الَّذِي أَرْسَلْتَ',
          translation: 'I believe in Your Book which You have revealed and in Your Prophet whom You have sent',
          reference: 'البخاري ١١:١١٣',
          repeatCount: 1,
          virtue: 10,
        ),
        const Azkar(
          id: 'sleep_11',
          arabicText: 'الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنَا وَسَقَانَا، وَكَفَانَا، وَآوَانَا، فَكَمْ مِمَّنْ لَا كَافِيَ لَهُ وَلَا مُؤْوِيَ',
          translation: 'All praise is for Allah, Who fed us and gave us drink, and Who is sufficient for us and has sheltered us, for how many have none to suffice them or shelter them',
          reference: 'مسلم ٤:٢٠٨٣',
          repeatCount: 1,
          virtue: 10,
        ),
        const Azkar(
          id: 'sleep_12',
          arabicText: 'اللَّهُمَّ عَالِمَ الْغَيْبِ وَالشَّهَادَةِ فَاطِرَ السَّمَاوَاتِ وَالْأَرْضِ، رَبَّ كُلِّ شَيْءٍ وَمَلِيكَهُ',
          translation: 'O Allah, Knower of the unseen and the seen, Creator of the heavens and the Earth, Lord and Sovereign of all things',
          reference: 'الترمذي ٣:١٤٢',
          repeatCount: 1,
          virtue: 10,
        ),
        const Azkar(
          id: 'sleep_13',
          arabicText: 'اللَّهُمَّ رَبَّ السَّمَاوَاتِ وَرَبَّ الْأَرْضِ وَرَبَّ الْعَرْشِ الْعَظِيمِ',
          translation: 'O Allah, Lord of the heavens and Lord of the Earth and Lord of the Magnificent Throne',
          reference: 'مسلم ٤:٢٠٨٤',
          repeatCount: 1,
          virtue: 10,
        ),
        const Azkar(
          id: 'sleep_14',
          arabicText: 'أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ',
          translation: 'I seek refuge in the perfect words of Allah from the evil of what He has created',
          reference: 'مسلم ٤:٢٠٨١',
          repeatCount: 3,
          virtue: 10,
        ),
        const Azkar(
          id: 'sleep_15',
          arabicText: 'اللَّهُمَّ إِنِّي أَعُوذُ بِوَجْهِكَ الْكَرِيمِ وَكَلِمَاتِكَ التَّامَّةِ مِنْ شَرِّ مَا أَنْتَ آخِذٌ بِنَاصِيَتِهِ',
          translation: 'O Allah, I seek refuge in Your noble face and Your perfect words from the evil of what You control',
          reference: 'أبو داود ٤:٣١٧',
          repeatCount: 1,
          virtue: 10,
        ),
      ];
    case 'wake':
      return [
        const Azkar(
          id: 'wake_1',
          arabicText: 'الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ',
          translation: 'All praise is for Allah who gave us life after having taken it from us and unto Him is the resurrection',
          reference: 'البخاري ١١:١١٣',
          repeatCount: 1,
          virtue: 10,
        ),
        const Azkar(
          id: 'wake_2',
          arabicText: 'لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ، وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ',
          translation: 'None has the right to be worshipped except Allah, alone, without partner, to Him belongs all sovereignty and praise and He is over all things omnipotent',
          reference: 'البخاري ٨:٧٥',
          repeatCount: 1,
          virtue: 10,
        ),
        const Azkar(
          id: 'wake_3',
          arabicText: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
          translation: 'Glory and praise be to Allah',
          reference: 'البخاري ٨:٧٥',
          repeatCount: 33,
          virtue: 10,
        ),
        const Azkar(
          id: 'wake_4', 
          arabicText: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ عِلْمًا نَافِعًا، وَرِزْقًا طَيِّبًا، وَعَمَلًا مُتَقَبَّلًا',
          translation: 'O Allah, I ask You for beneficial knowledge, pure provision, and accepted deeds',
          reference: 'ابن ماجه ١:٩٢٥',
          repeatCount: 1,
          virtue: 10,
        ),
        const Azkar(
          id: 'wake_5',
          arabicText: 'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَهَ إِلاَّ اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ',
          translation: 'We have reached the morning and at this very time all sovereignty belongs to Allah. All praise is for Allah. None has the right to be worshipped except Allah, alone, without any partner',
          reference: 'أبو داود ٤:٣١٧',
          repeatCount: 1,
          virtue: 10,
        ),
        const Azkar(
          id: 'wake_6',
          arabicText: 'اللَّهُمَّ بِكَ أَصْبَحْنَا، وَبِكَ أَمْسَيْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ، وَإِلَيْكَ النُّشُورُ',
          translation: 'O Allah, by You we enter the morning and by You we enter the evening, by You we live and by You we die, and to You is the resurrection',
          reference: 'الترمذي ٥:٤٦٦',
          repeatCount: 1,
          virtue: 10,
        ),
        const Azkar(
          id: 'wake_7',
          arabicText: 'اللَّهُمَّ عَافِنِي فِي بَدَنِي، اللَّهُمَّ عَافِنِي فِي سَمْعِي، اللَّهُمَّ عَافِنِي فِي بَصَرِي',
          translation: 'O Allah, grant me health in my body. O Allah, grant me health in my hearing. O Allah, grant me health in my sight',
          reference: 'أبو داود ٤:٣٢٤',
          repeatCount: 3,
          virtue: 10,
        ),
        const Azkar(
          id: 'wake_8',
          arabicText: 'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْكُفْرِ وَالْفَقْرِ، اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنْ عَذَابِ الْقَبْرِ، لَا إِلَهَ إِلَّا أَنْتَ',
          translation: 'O Allah, I seek refuge in You from disbelief and poverty. O Allah, I seek refuge in You from the punishment of the grave. There is none worthy of worship but You',
          reference: 'أبو داود ٤:٣٢٤',
          repeatCount: 1,
          virtue: 10,
        ),
        const Azkar(
          id: 'wake_9',
          arabicText: 'حَسْبِيَ اللَّهُ لَا إِلَهَ إِلَّا هُوَ عَلَيْهِ تَوَكَّلْتُ وَهُوَ رَبُّ الْعَرْشِ الْعَظِيمِ',
          translation: 'Allah is sufficient for me. There is none worthy of worship but Him. I have placed my trust in Him, He is Lord of the Majestic Throne',
          reference: 'أبو داود ٤:٣٢١',
          repeatCount: 7,
          virtue: 10,
        ),
        const Azkar(
          id: 'wake_10',
          arabicText: 'رَضِيتُ بِاللَّهِ رَبًّا، وَبِالْإِسْلَامِ دِينًا، وَبِمُحَمَّدٍ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ نَبِيًّا',
          translation: 'I am pleased with Allah as my Lord, with Islam as my religion, and with Muhammad (peace be upon him) as my Prophet',
          reference: 'أبو داود ٤:٣١٨',
          repeatCount: 3,
          virtue: 10,
        ),
        const Azkar(
          id: 'wake_11',
          arabicText: 'يَا حَيُّ يَا قَيُّومُ بِرَحْمَتِكَ أَسْتَغِيثُ، أَصْلِحْ لِي شَأْنِي كُلَّهُ، وَلَا تَكِلْنِي إِلَى نَفْسِي طَرْفَةَ عَيْنٍ',
          translation: 'O Ever Living, O Self-Subsisting and Supporter of all, by Your mercy I seek assistance, rectify for me all of my affairs and do not leave me to myself, even for the blink of an eye',
          reference: 'النسائي ٣:٥٢',
          repeatCount: 1,
          virtue: 10,
        ),
        const Azkar(
          id: 'wake_12',
          arabicText: 'أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ',
          translation: 'I seek refuge in Allah\'s perfect words from the evil of what He has created',
          reference: 'مسلم ٤:٢٠٨١',
          repeatCount: 3,
          virtue: 10,
        ),
        const Azkar(
          id: 'wake_13',
          arabicText: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفْوَ وَالْعَافِيَةَ فِي الدُّنْيَا وَالْآخِرَةِ',
          translation: 'O Allah, I ask You for pardon and well-being in this life and the next',
          reference: 'ابن ماجه ٢:٣٨٧١',
          repeatCount: 1,
          virtue: 10,
        ),
        const Azkar(
          id: 'wake_14',
          arabicText: 'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْهَمِّ وَالْحَزَنِ، وَالْعَجْزِ وَالْكَسَلِ، وَالْبُخْلِ وَالْجُبْنِ، وَضَلَعِ الدَّيْنِ وَغَلَبَةِ الرِّجَالِ',
          translation: 'O Allah, I seek refuge in You from anxiety and sorrow, weakness and laziness, miserliness and cowardice, the burden of debts and from being overpowered by men',
          reference: 'البخاري ٨:٧٩',
          repeatCount: 1,
          virtue: 10,
        ),
        const Azkar(
          id: 'wake_15',
          arabicText: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ عَدَدَ خَلْقِهِ، وَرِضَا نَفْسِهِ، وَزِنَةَ عَرْشِهِ، وَمِدَادَ كَلِمَاتِهِ',
          translation: 'Glory and praise be to Allah, by the number of His creation, by His pleasure, by the weight of His throne, and by the extent of His words',
          reference: 'مسلم ٤:٢٧٢٦',
          repeatCount: 3,
          virtue: 10,
        )
        //Add more items to reach 15+
      ];
    case 'prayer':
      return [
        const Azkar(
          id: 'prayer_1',
          arabicText: 'أَسْتَغْفِرُ اللَّهَ، أَسْتَغْفِرُ اللَّهَ، أَسْتَغْفِرُ اللَّهَ',
          translation: 'I seek forgiveness from Allah, I seek forgiveness from Allah, I seek forgiveness from Allah',
          reference: 'مسلم ١:٥٩١',
          repeatCount: 3,
          virtue: 10,
        ),
        const Azkar(
          id: 'prayer_2',
          arabicText: 'اللَّهُمَّ أَنْتَ السَّلَامُ، وَمِنْكَ السَّلَامُ، تَبَارَكْتَ يَا ذَا الْجَلَالِ وَالْإِكْرَامِ',
          translation: 'O Allah, You are As-Salam and from You is all peace, blessed are You, O Owner of majesty and honor',
          reference: 'مسلم ١:٥٩٢',
          repeatCount: 1,
          virtue: 10,
        ),
        const Azkar(
          id: 'prayer_3',
          arabicText: 'لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ، اللَّهُمَّ لَا مَانِعَ لِمَا أَعْطَيْتَ، وَلَا مُعْطِيَ لِمَا مَنَعْتَ، وَلَا يَنْفَعُ ذَا الْجَدِّ مِنْكَ الْجَدُّ',
          translation: 'None has the right to be worshipped except Allah, alone, without partner, to Him belongs all sovereignty and praise and He is over all things omnipotent. O Allah, none can prevent what You have willed to bestow and none can bestow what You have willed to prevent, and no wealth or majesty can benefit anyone, as from You is all wealth and majesty',
          reference: 'البخاري ١:٢٥٥',
          repeatCount: 1,
          virtue: 10,
        ),
        const Azkar(
          id: 'prayer_4',
          arabicText: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
          translation: 'Glory and praise be to Allah',
          reference: 'مسلم ٤:٢٠٧١',
          repeatCount: 33,
          virtue: 10,
        ),
        const Azkar(
          id: 'prayer_5',
          arabicText: 'اللَّهُ أَكْبَرُ',
          translation: 'Allah is the greatest',
          reference: 'مسلم ٤:٢٠٧١',
          repeatCount: 33,
          virtue: 10,
        ),
        const Azkar(
          id: 'prayer_6',
          arabicText: 'الْحَمْدُ لِلَّهِ',
          translation: 'All praise is for Allah',
          reference: 'مسلم ٤:٢٠٧١',
          repeatCount: 33,
          virtue: 10,
        ),
        const Azkar(
          id: 'prayer_7',
          arabicText: 'لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ',
          translation: 'None has the right to be worshipped except Allah, alone, without partner, to Him belongs all sovereignty and praise and He is over all things omnipotent',
          reference: 'مسلم ٤:٢٠٧١',
          repeatCount: 1,
          virtue: 10,
        ),
        const Azkar(
          id: 'prayer_8',
          arabicText: 'اللَّهُمَّ أَعِنِّي عَلَى ذِكْرِكَ وَشُكْرِكَ وَحُسْنِ عِبَادَتِكَ',
          translation: 'O Allah, help me to remember You, to thank You, and to worship You in the best way',
          reference: 'أبو داود ٢:١٥٢٢',
          repeatCount: 1,
          virtue: 10,
        ),
        const Azkar(
          id: 'prayer_9',
          arabicText: 'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْبُخْلِ، وَأَعُوذُ بِكَ مِنَ الْجُبْنِ، وَأَعُوذُ بِكَ مِنْ أَنْ أُرَدَّ إِلَى أَرْذَلِ الْعُمُرِ، وَأَعُوذُ بِكَ مِنْ فِتْنَةِ الدُّنْيَا وَعَذَابِ الْقَبْرِ',
          translation: 'O Allah, I seek refuge in You from miserliness, and I seek refuge in You from cowardice, and I seek refuge in You from being returned to senile old age, and I seek refuge in You from the trials of this world and the punishment of the grave',
          reference: 'البخاري ٨:٧٩',
          repeatCount: 1,
          virtue: 10,
        ),
        const Azkar(
          id: 'prayer_10',
          arabicText: 'اللَّهُمَّ اغْفِرْ لِي، وَارْحَمْنِي، وَاهْدِنِي، وَعَافِنِي وَارْزُقْنِي',
          translation: 'O Allah, forgive me, have mercy upon me, guide me, give me good health and provide for me',
          reference: 'مسلم ٤:٢٠٧٣',
          repeatCount: 1,
          virtue: 10,
        ),
        const Azkar(
          id: 'prayer_11',
          arabicText: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ الْهُدَى وَالتُّقَى وَالْعَفَافَ وَالْغِنَى',
          translation: 'O Allah, I ask You for guidance, piety, chastity and self-sufficiency',
          reference: 'مسلم ٤:٢٠٧٢',
          repeatCount: 1,
          virtue: 10,
        ),
        const Azkar(
          id: 'prayer_12',
          arabicText: 'اللَّهُمَّ إِنِّي ظَلَمْتُ نَفْسِي ظُلْمًا كَثِيرًا، وَلَا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ، فَاغْفِرْ لِي مَغْفِرَةً مِنْ عِنْدِكَ، وَارْحَمْنِي، إِنَّكَ أَنْتَ الْغَفُورُ الرَّحِيمُ',
          translation: 'O Allah, I have greatly wronged myself and no one forgives sins but You. So, grant me forgiveness and have mercy on me. Surely, You are the Most Forgiving, Most Merciful',
          reference: 'البخاري ٨:٩٩',
          repeatCount: 1,
          virtue: 10,
        ),
        const Azkar(
          id: 'prayer_13',
          arabicText: 'رَبِّ اغْفِرْ لِي وَتُبْ عَلَيَّ إِنَّكَ أَنْتَ التَّوَّابُ الرَّحِيمُ',
          translation: 'My Lord, forgive me and accept my repentance, for You are the Ever-Accepting of repentance, Most Merciful',
          reference: 'أبو داود ٢:١٥١٦',
          repeatCount: 1,
          virtue: 10,
        ),
        const Azkar(
          id: 'prayer_14',
          arabicText: 'اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ كَمَا صَلَّيْتَ عَلَى إِبْرَاهِيمَ وَعَلَى آلِ إِبْرَاهِيمَ إِنَّكَ حَمِيدٌ مَجِيدٌ',
          translation: 'O Allah, send prayers upon Muhammad and upon the family of Muhammad, just as You sent prayers upon Ibrahim and upon the family of Ibrahim. Indeed, You are praiseworthy and glorious',
          reference: 'البخاري ٤:٣٣٧٠',
          repeatCount: 1,
          virtue: 10,
        ),
        const Azkar(
          id: 'prayer_15',
          arabicText: 'اللَّهُمَّ رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ',
          translation: 'O Allah, our Lord, give us in this world [that which is] good and in the Hereafter [that which is] good and protect us from the punishment of the Fire',
          reference: 'البخاري ٨:٧٥',
          repeatCount: 1,
          virtue: 10,
        )
        // Add more items to reach 15+
      ];
    case 'quran':
      return [
        const Azkar(
          id: 'quran_1',
          arabicText: 'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ',
          translation: 'Our Lord, give us in this world [that which is] good and in the Hereafter [that which is] good and protect us from the punishment of the Fire',
          reference: 'البخاري ٢:٢٠١',
          repeatCount: 1,
          virtue: 10,
        ),
        const Azkar(
          id: 'quran_2',
          arabicText: 'رَبَّنَا لَا تُؤَاخِذْنَا إِن نَّسِينَا أَوْ أَخْطَأْنَا',
          translation: 'Our Lord, do not impose blame upon us if we have forgotten or erred',
          reference: 'البخاري ٢:٢٨٦',
          repeatCount: 1,
          virtue: 10,
        ),
        const Azkar(
          id: 'quran_3',
          arabicText: 'رَبَّنَا تَقَبَّلْ مِنَّا ۖ إِنَّكَ أَنتَ السَّمِيعُ الْعَلِيمُ',
          translation: 'Our Lord, accept [this] from us. Indeed, You are the All-Hearing, the All-Knowing',
          reference: 'البخاري ٢:١٢٧',
          repeatCount: 1,
          virtue: 10,
        ),
        const Azkar(
          id: 'quran_4',
          arabicText: 'رَبِّ اشْرَحْ لِي صَدْرِي وَيَسِّرْ لِي أَمْرِي',
          translation: 'My Lord, expand for me my breast [with assurance] and ease for me my task',
          reference: 'البخاري ٢٠:٢٥-٢٦',
          repeatCount: 1,
          virtue: 10,
        ),
        const Azkar(
          id: 'quran_5',
          arabicText: 'رَبَّنَا اغْفِرْ لِي وَلِوَالِدَيَّ وَلِلْمُؤْمِنِينَ يَوْمَ يَقُومُ الْحِسَابُ',
          translation: 'Our Lord, forgive me and my parents and the believers the Day the account is established',
          reference: 'البخاري ١٤:٤١',
          repeatCount: 1,
          virtue: 10,
        ),
        const Azkar(
          id: 'quran_6',
          arabicText: 'رَبِّ زِدْنِي عِلْمًا',
          translation: 'My Lord, increase me in knowledge',
          reference: 'البخاري ٢٠:١١٤',
          repeatCount: 1,
          virtue: 10,
        ),
        const Azkar(
          id: 'quran_7',
          arabicText: 'رَبَّنَا لَا تُزِغْ قُلُوبَنَا بَعْدَ إِذْ هَدَيْتَنَا وَهَبْ لَنَا مِن لَّدُنكَ رَحْمَةً',
          translation: 'Our Lord, let not our hearts deviate after You have guided us and grant us from Yourself mercy',
          reference: 'البخاري ٣:٨',
          repeatCount: 1,
          virtue: 10,
        ),
        const Azkar(
          id: 'quran_8',
          arabicText: 'رَبَّنَا آمَنَّا فَاغْفِرْ لَنَا وَارْحَمْنَا وَأَنتَ خَيْرُ الرَّاحِمِينَ',
          translation: 'Our Lord, we have believed, so forgive us and have mercy upon us, and You are the best of the merciful',
          reference: 'البخاري ٢٣:١٠٩',
          repeatCount: 1,
          virtue: 10,
        ),
        const Azkar(
          id: 'quran_9',
          arabicText: 'رَبِّ أَعُوذُ بِكَ مِنْ هَمَزَاتِ الشَّيَاطِينِ وَأَعُوذُ بِكَ رَبِّ أَن يَحْضُرُونِ',
          translation: 'My Lord, I seek refuge in You from the incitements of the devils, and I seek refuge in You, my Lord, lest they be present with me',
          reference: 'البخاري ٢٣:٩٧-٩٨',
          repeatCount: 1,
          virtue: 10,
        ),
        const Azkar(
          id: 'quran_10',
          arabicText: 'رَبَّنَا هَبْ لَنَا مِنْ أَزْوَاجِنَا وَذُرِّيَّاتِنَا قُرَّةَ أَعْيُنٍ وَاجْعَلْنَا لِلْمُتَّقِينَ إِمَامًا',
          translation: 'Our Lord, grant us from among our wives and offspring comfort to our eyes and make us an example for the righteous',
          reference: 'البخاري ٢٥:٧٤',
          repeatCount: 1,
          virtue: 10,
        ),
        const Azkar(
          id: 'quran_11',
          arabicText: 'رَبِّ اجْعَلْنِي مُقِيمَ الصَّلَاةِ وَمِن ذُرِّيَّتِي ۚ رَبَّنَا وَتَقَبَّلْ دُعَاءِ',
          translation: 'My Lord, make me an establisher of prayer, and [many] from my descendants. Our Lord, and accept my supplication',
          reference: 'البخاري ١٤:٤٠',
          repeatCount: 1,
          virtue: 10,
        ),
        const Azkar(
          id: 'quran_12',
          arabicText: 'رَبَّنَا اصْرِفْ عَنَّا عَذَابَ جَهَنَّمَ ۖ إِنَّ عَذَابَهَا كَانَ غَرَامًا',
          translation: 'Our Lord, avert from us the punishment of Hell. Indeed, its punishment is ever adhering',
          reference: 'البخاري ٢٥:٦٥',
          repeatCount: 1,
          virtue: 10,
        ),
        const Azkar(
          id: 'quran_13',
          arabicText: 'رَبَّنَا أَفْرِغْ عَلَيْنَا صَبْرًا وَثَبِّتْ أَقْدَامَنَا وَانصُرْنَا عَلَى الْقَوْمِ الْكَافِرِينَ',
          translation: 'Our Lord, pour upon us patience and plant firmly our feet and give us victory over the disbelieving people',
          reference: 'البخاري ٢:٢٥٠',
          repeatCount: 1,
          virtue: 10,
        ),
        const Azkar(
          id: 'quran_14',
          arabicText: 'رَبَّنَا اغْفِرْ لَنَا ذُنُوبَنَا وَإِسْرَافَنَا فِي أَمْرِنَا وَثَبِّتْ أَقْدَامَنَا وَانصُرْنَا عَلَى الْقَوْمِ الْكَافِرِينَ',
          translation: 'Our Lord, forgive us our sins and excesses in our affairs and plant firmly our feet and give us victory over the disbelieving people',
          reference: 'البخاري ٣:١٤٧',
          repeatCount: 1,
          virtue: 10,
        ),
        const Azkar(
          id: 'quran_15',
          arabicText: 'رَبِّ أَوْزِعْنِي أَنْ أَشْكُرَ نِعْمَتَكَ الَّتِي أَنْعَمْتَ عَلَيَّ وَعَلَىٰ وَالِدَيَّ',
          translation: 'My Lord, enable me to be grateful for Your favor which You have bestowed upon me and upon my parents',
          reference: 'البخاري ٢٧:١٩',
          repeatCount: 1,
          virtue: 10,
        ),
        // Add more items to reach 15+
      ];
    default:
      return [];
  }
});

final azkarRepeatCountsProvider = StateNotifierProvider<AzkarRepeatCountsNotifier, Map<String, int>>((ref) {
  return AzkarRepeatCountsNotifier();
});

class AzkarRepeatCountsNotifier extends StateNotifier<Map<String, int>> {
  AzkarRepeatCountsNotifier() : super({});

  void initializeCount(String azkarId, int repeatCount) {
    if (!state.containsKey(azkarId)) {
      state = {...state, azkarId: repeatCount};
    }
  }

  void decrementCount(String azkarId) {
    if (state.containsKey(azkarId) && state[azkarId]! > 0) {
      state = {...state, azkarId: state[azkarId]! - 1};
    }
  }

  void resetCount(String azkarId, int repeatCount) {
    state = {...state, azkarId: repeatCount};
  }

  bool isCompleted(String azkarId) {
    return state.containsKey(azkarId) && state[azkarId] == 0;
  }
}