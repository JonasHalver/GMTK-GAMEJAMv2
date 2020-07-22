using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Shooting : MonoBehaviour
{
    Camera cam;
    public float weaponDamage = 1f;
    public Light muzzleFlash;
    public LayerMask targetMask, obstacleMask;
    public GameObject trail;
    public GameObject sparks;

    public GameObject flash;

    AudioSource sound;
    int shotCount = 0;
    Material playerMat;
    bool flag;

    // Start is called before the first frame update
    void Start()
    {
        cam = Camera.main;
        sound = GetComponent<AudioSource>();
        playerMat = transform.parent.GetComponent<SpriteRenderer>().material;
    }

    // Update is called once per frame
    void Update()
    {
        if (MoveController.active)
        {
            if (Input.GetButtonDown("Fire1") && (!Input.GetButton("Sprint") || (Input.GetMouseButton(1) && Input.GetButton("Sprint"))))
            {
                Shoot();
            }
        }
    }

    public void Shoot()
    {
        Life target = null;

        sound.Play();

        RaycastHit hit, hit2;
        Vector2 midpoint = new Vector2(Screen.width / 2, Screen.height / 2);
        
        Ray ray = cam.ViewportPointToRay(new Vector3(0.5f, 0.5f, 0));//cam.ScreenPointToRay(midpoint);

        if (Physics.Raycast(ray, out hit, Mathf.Infinity, targetMask))
        {            
            StartCoroutine("Flash", hit);
            if (!hit.transform.CompareTag("Wall") || hit.transform.CompareTag("Floor"))
            {
                if (hit.transform.GetComponent<Life>())
                {
                    target = hit.transform.GetComponent<Life>();
                }
            }
        }

        if (target)
        {
            target.Hit(target.isHead ? weaponDamage * 2 : weaponDamage);
        }

    }

    IEnumerator Flash(RaycastHit hit)
    {
        muzzleFlash.enabled = true;
        playerMat.EnableKeyword("_RIMLIGHTFLASH_ON");
        GameObject newTrail = Instantiate(trail, transform.position, cam.transform.rotation);
        newTrail.transform.LookAt(hit.point);
        newTrail.GetComponent<ParticleSystem>().Play();
        GameObject newFlash = Instantiate(flash, transform.position, Quaternion.identity);        
        if (hit.transform.CompareTag("Machine"))
        {
            GameObject newSparks = Instantiate(sparks, hit.point, Quaternion.identity);
            newSparks.transform.LookAt(transform);
            shotCount++;
            if (shotCount == 5)
            {
                GameManager.instance.SendMessage("Trigger", 7);
            }
        }
        else if (hit.transform.CompareTag("Button"))
        {
            if (!flag)
            {
                flag = true;
                GameManager.instance.fadeToWhite.SetBool("FadeToWhite", true);
                StartCoroutine(Wait());
            }
        }
        yield return new WaitForSeconds(0.1f);
        muzzleFlash.enabled = false;
        playerMat.DisableKeyword("_RIMLIGHTFLASH_ON");

    }
    IEnumerator Wait()
    {
        yield return new WaitForSecondsRealtime(7.5f);
        GameManager.instance.Reload();
    }
}
