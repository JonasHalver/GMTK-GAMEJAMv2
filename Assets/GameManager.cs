using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Audio;
using TMPro;
using UnityEngine.SceneManagement;

public class GameManager : MonoBehaviour
{
    public static GameManager instance;
    public AudioSource sound;
    public List<AudioClip> voiceLines = new List<AudioClip>();
    public GameObject subtitleObject;
    public TextMeshProUGUI subtitles;
    public Color green, pink, teal;

    public AudioMixer mixer;

    public List<int> usedLines = new List<int>();

    public Animator fadeToWhite;

    public GameObject objectives;
    public GameObject obj1, obj2, obj3, obj4, obj5, obj6, obj7, obj8;

    public GameObject line;

    public IEnumerator lastLine;
    public List<IEnumerator> queuedLines = new List<IEnumerator>();
    public bool useQueue = true;
    public bool linePlaying = false;

    void Awake()
    {
        instance = this;
        MoveController.active = false;
    }

    // Start is called before the first frame update
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {
        if (!linePlaying)
        {
            if (queuedLines.Count > 0)
                StartCoroutine(queuedLines[0]);
        }
    }

    public void Trigger(int index)
    {
        if (!usedLines.Contains(index))
        {
            switch (index)
            {
                case 1:
                    if (!useQueue)
                    {
                        lastLine = Subtitle1();
                        StartCoroutine(lastLine);
                    }
                    else
                    {
                        queuedLines.Add(Subtitle1());
                    }
                        usedLines.Add(index);
                    
                    break;
                case 2:
                    if (!useQueue)
                    {
                        StartCoroutine(Subtitle2());
                    }
                    else
                    {
                        queuedLines.Add(Subtitle2());
                    }
                    usedLines.Add(index);
                    
                    break;
                case 3:
                    if (!useQueue)
                    {
                        sound.Stop();
                        objectives.SetActive(true);
                        obj1.SetActive(true);
                        StopCoroutine(lastLine);
                        lastLine = Subtitle3();
                        StartCoroutine(lastLine);
                    }
                    else
                    {
                        queuedLines.Add(Subtitle3());
                    }
                    usedLines.Add(index);
                    
                    break;
                case 4:
                    if (!useQueue)
                    {
                        sound.Stop();
                        line.SetActive(true);
                        StopCoroutine(lastLine);
                        lastLine = Subtitle4();
                        StartCoroutine(lastLine);
                    }
                    else
                    {
                        queuedLines.Add(Subtitle4());
                    }
                    usedLines.Add(index);
                    
                    break;
                case 5:
                    if (!useQueue)
                    {
                        sound.Stop();
                        obj2.SetActive(true);
                        StopCoroutine(lastLine);
                        lastLine = Subtitle5();
                        StartCoroutine(lastLine);
                    }
                    else
                    {
                        queuedLines.Add(Subtitle5());
                    }
                    usedLines.Add(index);
                    
                    break;
                case 6:
                    if (!useQueue)
                    {
                        sound.Stop();
                        StopCoroutine(lastLine);
                        lastLine = Subtitle6();
                        StartCoroutine(lastLine);
                    }
                    else
                    {
                        queuedLines.Add(Subtitle6());
                    }
                    usedLines.Add(index);
                    break;
                case 7:
                    if (!useQueue)
                    {
                        StartCoroutine(Subtitle7());
                    }
                    else
                    {
                        queuedLines.Add(Subtitle7());
                    }
                    usedLines.Add(index);
                    break;
                case 8:
                    if (!useQueue)
                    {
                        StartCoroutine(Subtitle8());
                    }
                    else
                    {
                        queuedLines.Add(Subtitle8());
                    }
                    usedLines.Add(index);
                    break;
                case 9:
                    if (!useQueue)
                    {
                        StartCoroutine(Subtitle9());
                    }
                    else
                    {
                        queuedLines.Add(Subtitle9());
                    }
                    usedLines.Add(index);
                    break;
                case 10:
                    if (!useQueue)
                    {
                        StartCoroutine(Subtitle10());
                    }
                    else
                    {
                        queuedLines.Add(Subtitle10());
                    }
                    usedLines.Add(index);
                    break;
                case 11:
                    if (!useQueue)
                    {
                        StartCoroutine(Subtitle11());
                    }
                    else
                    {
                        queuedLines.Add(Subtitle11());
                    }
                    usedLines.Add(index);
                    break;
                case 12:
                    if (!useQueue)
                    {
                        StartCoroutine(Subtitle12());
                    }
                    else
                    {
                        queuedLines.Add(Subtitle12());
                    }
                    usedLines.Add(index);
                    break;
                case 13:
                    if (!useQueue)
                    {
                        StartCoroutine(Subtitle13());
                    }
                    else
                    {
                        queuedLines.Add(Subtitle13());
                    }
                    usedLines.Add(index);
                    break;
                case 14:
                    if (!useQueue)
                    {
                        StartCoroutine(Subtitle14());
                    }
                    else
                    {
                        queuedLines.Add(Subtitle14());
                    }
                    usedLines.Add(index);
                    break;
                case 15:
                    if (!useQueue)
                    {
                        StartCoroutine(Subtitle15());
                    }
                    else
                    {
                        queuedLines.Add(Subtitle15());
                    }
                    usedLines.Add(index);
                    break;
            }
        }
    }

    IEnumerator Subtitle1()
    {
        linePlaying = true;
        mixer.SetFloat("SoundFXVol", -20);
        subtitleObject.SetActive(true);
        subtitles.text = "";
        yield return null;
        sound.PlayOneShot(voiceLines[0]);
        subtitles.text = "3 hours ago, this facility experienced an incident with one of their <#" + ColorUtility.ToHtmlStringRGBA(pink) + ">research projects.</color>";
        fadeToWhite.SetBool("FadeFromBlack", true);
        yield return new WaitForSecondsRealtime(7f);
        MoveController.active = true;
        subtitles.text = "Everyone inside has been turned into... <#" + ColorUtility.ToHtmlStringRGBA(teal) + ">Something else.</color>";
        yield return new WaitForSecondsRealtime(4f);

        subtitles.text = "<#" + ColorUtility.ToHtmlStringRGBA(pink) + ">The Machine</color> responsible is now threatening the outside world.";
        yield return new WaitForSecondsRealtime(4f);

        subtitles.text = "It is your job to <#" + ColorUtility.ToHtmlStringRGBA(green) + ">destroy</color> <#" + ColorUtility.ToHtmlStringRGBA(pink) + ">the Machine</color> and " +
            "<#" + ColorUtility.ToHtmlStringRGBA(green) + ">restore control of the facility</color>.";
        // QUEST MARKER
        yield return new WaitForSecondsRealtime(2f);
        objectives.SetActive(true);
        obj1.SetActive(true);
        yield return new WaitForSecondsRealtime(2.5f);

        subtitles.text = "You can expect <#" + ColorUtility.ToHtmlStringRGBA(teal) + ">resistance</color>. Acquaint yourself with your gear before heading out.";
        // TUT PROMPTS
        yield return new WaitForSecondsRealtime(5f);

        subtitleObject.SetActive(false);
        mixer.SetFloat("SoundFXVol", 0);

        queuedLines.RemoveAt(0);
        linePlaying = false;
    }

    IEnumerator Subtitle2()
    {
        linePlaying = true;
        subtitleObject.SetActive(true);
        subtitles.text = "";
        yield return null;
        sound.PlayOneShot(voiceLines[1]);
        subtitles.text = "I cannot recommend firing your weapon without a target, you may attract <#" + ColorUtility.ToHtmlStringRGBA(teal) + ">unwanted attention.</color>";
        yield return new WaitForSecondsRealtime(8f);
        subtitleObject.SetActive(false);

        queuedLines.RemoveAt(0);
        linePlaying = false;
    }
    IEnumerator Subtitle3()
    {
        linePlaying = true;
        if (sound.isPlaying)
            sound.Stop();
        mixer.SetFloat("SoundFXVol", -20);
        subtitleObject.SetActive(true);
        subtitles.text = "";
        yield return null;
        sound.PlayOneShot(voiceLines[2]);
        subtitles.text = "<#" + ColorUtility.ToHtmlStringRGBA(green) + ">Our team</color> has performed a scan of the facility.";
        yield return new WaitForSecondsRealtime(4f);
        subtitles.text = "Your <#" + ColorUtility.ToHtmlStringRGBA(green) + ">HUD</color> should show you the <#" + ColorUtility.ToHtmlStringRGBA(green) + ">fastest and safest route</color> to <#" + ColorUtility.ToHtmlStringRGBA(pink) + ">the Machine.</color>";
        // TURN ON GREEN LINE HERE
        line.SetActive(true);
        yield return new WaitForSecondsRealtime(10f);
        subtitleObject.SetActive(false);
        mixer.SetFloat("SoundFXVol", 0);

        queuedLines.RemoveAt(0);
        linePlaying = false;
    }
    IEnumerator Subtitle4()
    {
        linePlaying = true;
        if (sound.isPlaying)
            sound.Stop();
        mixer.SetFloat("SoundFXVol", -20);
        subtitleObject.SetActive(true);
        subtitles.text = "";
        yield return null;
        sound.PlayOneShot(voiceLines[3]);
        subtitles.text = "<#" + ColorUtility.ToHtmlStringRGBA(teal) + ">Those poor creatures</color> are all that remains of the scientists and researchers in the facility.";
        yield return new WaitForSecondsRealtime(6f);
        subtitles.text = "Nothing human remains, they are beyond <#" + ColorUtility.ToHtmlStringRGBA(pink) + ">redemption</color>. <#" + ColorUtility.ToHtmlStringRGBA(green) + ">Shoot on sight</color>.";
        // ADD QUEST "KILL ALL ENEMIES"
        obj2.SetActive(true);
        yield return new WaitForSecondsRealtime(6f);
        subtitleObject.SetActive(false);
        mixer.SetFloat("SoundFXVol", 0);

        queuedLines.RemoveAt(0);
        linePlaying = false;
    }
    IEnumerator Subtitle5()
    {
        linePlaying = true;
        if (sound.isPlaying)
            sound.Stop();
        mixer.SetFloat("SoundFXVol", -20);
        subtitleObject.SetActive(true);
        subtitles.text = "";
        yield return null;
        sound.PlayOneShot(voiceLines[4]);
        subtitles.text = "<#" + ColorUtility.ToHtmlStringRGBA(green) + ">Our scans</color> show movement up ahead. Expect <#" + ColorUtility.ToHtmlStringRGBA(teal) + ">heavy resistance</color>.";
        yield return new WaitForSecondsRealtime(5f);
        subtitleObject.SetActive(false);
        mixer.SetFloat("SoundFXVol", 0);

        queuedLines.RemoveAt(0);
        linePlaying = false;
    }
    IEnumerator Subtitle6()
    {
        linePlaying = true;
        if (sound.isPlaying)
            sound.Stop();
        mixer.SetFloat("SoundFXVol", -20);
        subtitleObject.SetActive(true);
        subtitles.text = "";
        yield return null;
        sound.PlayOneShot(voiceLines[5]);
        subtitles.text = "<#" + ColorUtility.ToHtmlStringRGBA(green) + ">Good work</color>. <#" + ColorUtility.ToHtmlStringRGBA(pink) + ">The Machine</color> is in the next room.";
        yield return new WaitForSecondsRealtime(3.5f);
        subtitles.text = "Destroying it will <#" + ColorUtility.ToHtmlStringRGBA(green) + ">restore control</color>, and wipe out any remaining <#" + ColorUtility.ToHtmlStringRGBA(teal) + ">enemies</color>.";
        yield return new WaitForSecondsRealtime(6f);
        subtitleObject.SetActive(false);
        mixer.SetFloat("SoundFXVol", 0);

        queuedLines.RemoveAt(0);
        linePlaying = false;
    }
    IEnumerator Subtitle7()
    {
        linePlaying = true;
        if (sound.isPlaying)
            sound.Stop();
        mixer.SetFloat("SoundFXVol", -20);
        subtitleObject.SetActive(true);
        subtitles.text = "";
        yield return null;
        sound.PlayOneShot(voiceLines[6]);
        subtitles.text = "That’s it! <#" + ColorUtility.ToHtmlStringRGBA(green) + ">Shoot it! KEEP SHOOTING</color>";
        obj1.SetActive(false);
        obj2.SetActive(false);
        obj3.SetActive(true);
        fadeToWhite.SetBool("FadeToWhite", true);
        yield return new WaitForSecondsRealtime(5f);
        subtitleObject.SetActive(false);
        Trigger(8);

        queuedLines.RemoveAt(0);
        linePlaying = false;
    }
    IEnumerator Subtitle8()
    {
        linePlaying = true;
        if (sound.isPlaying)
            sound.Stop();
        mixer.SetFloat("SoundFXVol", -80);
        subtitleObject.SetActive(true);
        subtitles.text = "";
        yield return null;
        sound.PlayOneShot(voiceLines[7]);
        subtitles.text = "Excellent work! The crisis is over. You’ve done well Soldier.";
        yield return new WaitForSecondsRealtime(7f);
        subtitleObject.SetActive(false);
        Reload();

        queuedLines.RemoveAt(0);
        linePlaying = false;
    }
    IEnumerator Subtitle9()
    {
        linePlaying = true;
        if (sound.isPlaying)
            sound.Stop();
        mixer.SetFloat("SoundFXVol", -20);
        subtitleObject.SetActive(true);
        subtitles.text = "";
        yield return null;
        sound.PlayOneShot(voiceLines[8]);
        subtitles.text = "Where are you going? Is your <#" + ColorUtility.ToHtmlStringRGBA(green) + ">HUD</color> malfunctioning?";
        yield return new WaitForSecondsRealtime(4f);
        subtitles.text = "* Can someone fix that? *";
        yield return new WaitForSecondsRealtime(1.5f);
        objectives.transform.localScale = new Vector3(2, 2, 2);
        yield return new WaitForSecondsRealtime(1.5f);
        // TURN OFF HUD HERE
        
        subtitleObject.SetActive(false);

        mixer.SetFloat("SoundFXVol", 0);

        queuedLines.RemoveAt(0);
        linePlaying = false;
    }
    IEnumerator Subtitle10()
    {
        linePlaying = true;
        if (sound.isPlaying)
            sound.Stop();
        mixer.SetFloat("SoundFXVol", -20);
        subtitleObject.SetActive(true);
        subtitles.text = "";
        yield return null;
        sound.PlayOneShot(voiceLines[9]);
        subtitles.text = "According to <#" + ColorUtility.ToHtmlStringRGBA(green) + ">our</color> scans, your <#" + ColorUtility.ToHtmlStringRGBA(pink) + ">current route</color> does not lead to the objective.";
        yield return new WaitForSecondsRealtime(4f);
        subtitles.text = "<#" + ColorUtility.ToHtmlStringRGBA(green) + ">Turn back!</color>";
        obj1.SetActive(false);
        obj2.SetActive(false);
        obj4.SetActive(true);
        yield return new WaitForSecondsRealtime(4f);
        
        subtitleObject.SetActive(false);
        mixer.SetFloat("SoundFXVol", 0);

        queuedLines.RemoveAt(0);
        linePlaying = false;
    }
    IEnumerator Subtitle11()
    {
        linePlaying = true;
        if (sound.isPlaying)
            sound.Stop();
        mixer.SetFloat("SoundFXVol", -20);
        subtitleObject.SetActive(true);
        subtitles.text = "";
        yield return null;
        sound.PlayOneShot(voiceLines[10]);
        subtitles.text = "There is no need to be stealthy and sneak around.";
        yield return new WaitForSecondsRealtime(3f);
        subtitles.text = "These... <#" + ColorUtility.ToHtmlStringRGBA(teal) + ">things</color>... Are not human anymore.";
        yield return new WaitForSecondsRealtime(3f);
        subtitles.text = "You can <#" + ColorUtility.ToHtmlStringRGBA(green) + ">just shoot</color> <#" + ColorUtility.ToHtmlStringRGBA(teal) + ">them!</color>";
        obj5.SetActive(true);
        yield return new WaitForSecondsRealtime(3f);
        subtitleObject.SetActive(false);
        mixer.SetFloat("SoundFXVol", 0);

        queuedLines.RemoveAt(0);
        linePlaying = false;
    }
    IEnumerator Subtitle12()
    {
        linePlaying = true;
        if (sound.isPlaying)
            sound.Stop();
        mixer.SetFloat("SoundFXVol", -20);
        subtitleObject.SetActive(true);
        subtitles.text = "";
        yield return null;
        sound.PlayOneShot(voiceLines[11]);
        subtitles.text = "Go back to <#" + ColorUtility.ToHtmlStringRGBA(green) + ">the marked path</color> now!";
        yield return new WaitForSecondsRealtime(4f);
        subtitles.text = "<#" + ColorUtility.ToHtmlStringRGBA(green) + ">That is an order!</color>";
        obj6.SetActive(true);
        yield return new WaitForSecondsRealtime(4f);
        subtitleObject.SetActive(false);
        mixer.SetFloat("SoundFXVol", 0);

        queuedLines.RemoveAt(0);
        linePlaying = false;
    }
    IEnumerator Subtitle13()
    {
        linePlaying = true;
        if (sound.isPlaying)
            sound.Stop();
        mixer.SetFloat("SoundFXVol", -20);
        subtitleObject.SetActive(true);
        subtitles.text = "";
        yield return null;
        sound.PlayOneShot(voiceLines[12]);
        subtitles.text = "* Is he not hearing <#" + ColorUtility.ToHtmlStringRGBA(green) + ">us</color>? Has <#" + ColorUtility.ToHtmlStringRGBA(pink) + ">the Machine</color> <#" + ColorUtility.ToHtmlStringRGBA(teal) + ">affected</color> him? *";
        yield return new WaitForSecondsRealtime(5f);
        subtitleObject.SetActive(false);
        mixer.SetFloat("SoundFXVol", 0);

        queuedLines.RemoveAt(0);
        linePlaying = false;
    }
    IEnumerator Subtitle14()
    {
        linePlaying = true;
        if (sound.isPlaying)
            sound.Stop();
        mixer.SetFloat("SoundFXVol", -20);
        subtitleObject.SetActive(true);
        subtitles.text = "";
        yield return null;
        sound.PlayOneShot(voiceLines[13]);
        subtitles.text = "Look, you don’t know what <#" + ColorUtility.ToHtmlStringRGBA(pink) + ">you’re doing</color>.";
        yield return new WaitForSecondsRealtime(2.5f);
        subtitles.text = "<#" + ColorUtility.ToHtmlStringRGBA(green) + ">Please. Just. Turn. Back</color>!";
        yield return new WaitForSecondsRealtime(5f);
        subtitleObject.SetActive(false);
        mixer.SetFloat("SoundFXVol", 0);

        queuedLines.RemoveAt(0);
        linePlaying = false;
    }
    IEnumerator Subtitle15()
    {
        linePlaying = true;
        if (sound.isPlaying)
            sound.Stop();
        mixer.SetFloat("SoundFXVol", -20);
        subtitleObject.SetActive(true);
        subtitles.text = "";
        yield return null;
        obj4.SetActive(false);
        obj5.SetActive(false);
        obj6.SetActive(false);
        obj7.SetActive(true);
        obj8.SetActive(true);
        sound.PlayOneShot(voiceLines[14]);
        subtitles.text = "No! Don’t <#" + ColorUtility.ToHtmlStringRGBA(pink) + ">press that button</color>!";
        yield return new WaitForSecondsRealtime(6f);
        subtitleObject.SetActive(false);

        queuedLines.RemoveAt(0);
        linePlaying = false;
    }

    public void Reload()
    {
        SceneManager.LoadScene(0);
    }
}
