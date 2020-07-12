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

    // Start is called before the first frame update
    void Start()
    {
        cam = Camera.main;
        sound = GetComponent<AudioSource>();
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetButtonDown("Fire1") && !Input.GetButton("Sprint"))
        {
            Shoot();
        }
    }

    public void Shoot()
    {
        Life target = null;

        sound.Play();

        RaycastHit hit, hit2;
        Vector2 midpoint = new Vector2(Screen.width / 2, Screen.height / 2);
        Ray ray = cam.ScreenPointToRay(midpoint);

        if (Physics.Raycast(ray, out hit, Mathf.Infinity, targetMask))
        {
            float dist = hit.distance;
            if (!Physics.Raycast(ray, out hit2, dist, obstacleMask))
            {
                if (hit.collider.GetComponent<Life>())
                {
                    target = hit.collider.GetComponent<Life>();
                }
            }
        }

        if (Physics.Raycast(ray, out hit2, Mathf.Infinity, targetMask+obstacleMask))
        {
            if (hit2.collider)
            {
                StartCoroutine(Flash(hit2));
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
        GameObject newTrail = Instantiate(trail, transform.position, cam.transform.rotation);
        newTrail.transform.LookAt(hit.point);
        newTrail.GetComponent<ParticleSystem>().Play();
        GameObject newFlash = Instantiate(flash, transform.position, Quaternion.identity);
        yield return new WaitForSeconds(0.1f);
        if (hit.collider.CompareTag("Machine"))
        {
            GameObject newSparks = Instantiate(sparks, hit.point, Quaternion.identity);
            newSparks.transform.LookAt(transform);
        }
        muzzleFlash.enabled = false;

    }
}
