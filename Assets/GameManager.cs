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
        if (Input.GetKeyDown(KeyCode.Space))
            StartCoroutine(Subtitle15());
    }

    public void Trigger(int index)
    {
        if (!usedLines.Contains(index))
        {
            switch (index)
            {
                case 1:
                    lastLine = Subtitle1();
                    StartCoroutine(lastLine);
                    usedLines.Add(index);
                    break;
                case 2:
                    StartCoroutine(Subtitle2());
                    usedLines.Add(index);
                    break;
                case 3:
                    sound.Stop();
                    objectives.SetActive(true);
                    obj1.SetActive(true);
                    StopCoroutine(lastLine);
                    lastLine = Subtitle3();
                    StartCoroutine(lastLine);
                    usedLines.Add(index);
                    break;
                case 4:
                    sound.Stop();                    
                    line.SetActive(true);
                    StopCoroutine(lastLine);
                    lastLine = Subtitle4();
                    StartCoroutine(lastLine);
                    usedLines.Add(index);
                    break;
                case 5:
                    sound.Stop();
                    obj2.SetActive(true);
                    StopCoroutine(lastLine);
                    lastLine = Subtitle5();
                    StartCoroutine(lastLine);
                    usedLines.Add(index);
                    break;
                case 6:
                    sound.Stop();
                    StopCoroutine(lastLine);
                    lastLine = Subtitle6();
                    StartCoroutine(lastLine);
                    usedLines.Add(index);
                    break;
                case 7:
                    StartCoroutine(Subtitle7());
                    usedLines.Add(index);
                    break;
                case 8:
                    StartCoroutine(Subtitle8());
                    usedLines.Add(index);
                    break;
                case 9:
                    StartCoroutine(Subtitle9());
                    usedLines.Add(index);
                    break;
                case 10:
                    StartCoroutine(Subtitle10());
                    usedLines.Add(index);
                    break;
                case 11:
                    StartCoroutine(Subtitle11());
                    usedLines.Add(index);
                    break;
                case 12:
                    StartCoroutine(Subtitle12());
                    usedLines.Add(index);
                    break;
                case 13:
                    StartCoroutine(Subtitle13());
                    usedLines.Add(index);
                    break;
                case 14:
                    StartCoroutine(Subtitle14());
                    usedLines.Add(index);
                    break;
                case 15:
                    StartCoroutine(Subtitle15());
                    usedLines.Add(index);
                    break;
            }
        }
    }

    IEnumerator Subtitle1()
    {
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
    }

    IEnumerator Subtitle2()
    {
        subtitleObject.SetActive(true);
        subtitles.text = "";
        yield return null;
        sound.PlayOneShot(voiceLines[1]);
        subtitles.text = "I cannot recommend firing your weapon without a target, you may attract <#" + ColorUtility.ToHtmlStringRGBA(teal) + ">unwanted attention.</color>";
        yield return new WaitForSecondsRealtime(8f);
        subtitleObject.SetActive(false);
    }
    IEnumerator Subtitle3()
    {
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
    }
    IEnumerator Subtitle4()
    {
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
    }
    IEnumerator Subtitle5()
    {
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
    }
    IEnumerator Subtitle6()
    {
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
    }
    IEnumerator Subtitle7()
    {
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
    }
    IEnumerator Subtitle8()
    {
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
    }
    IEnumerator Subtitle9()
    {
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
    }
    IEnumerator Subtitle10()
    {
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
    }
    IEnumerator Subtitle11()
    {
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
    }
    IEnumerator Subtitle12()
    {
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
    }
    IEnumerator Subtitle13()
    {
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
    }
    IEnumerator Subtitle14()
    {
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
    }
    IEnumerator Subtitle15()
    {
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
    }

    public void Reload()
    {
        SceneManager.LoadScene(0);
    }
}
